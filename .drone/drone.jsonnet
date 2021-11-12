local createTag(tag) = {
	name: "create-tag-" + tag,
	kind: "pipeline",
	type: "docker",
	trigger: {branch: [tag]},

	steps: [{
		name: tag,
		image: "proget.hunterwittenborn.com/docker/makedeb/makedeb-alpha:ubuntu-focal",
		environment: {
			ssh_key: {from_secret: "ssh_key"},
			known_hosts: {from_secret: "known_hosts"},
			release_type: tag
		},

		commands: [
			"sudo apt-get install openssh-client git jq -yq",
			".drone/scripts/create_tag.sh"
		]
	}]
};

local buildAndPublish(package_name, tag, image_name) = {
	name: "build-and-publish-" + tag,
	kind: "pipeline",
	type: "docker",
	trigger: {branch: [tag]},
	depends_on: ["create-tag-" + tag],
	steps: [
		{
			name: "build-debian-package",
			image: "proget.hunterwittenborn.com/docker/makedeb/" + image_name + ":ubuntu-focal",
			environment: {release_type: tag, package_name: package_name},
			commands: [
				"sudo -E apt-get install tzdata git jq sudo sed -yq",
				"sudo chown 'makedeb:makedeb' ./ -R",
				".drone/scripts/build.sh"
			]
        	},

		{
			name: "publish-proget",
			image: "proget.hunterwittenborn.com/docker/makedeb/makedeb-alpha:ubuntu-focal",
			environment: {proget_api_key: {from_secret: "proget_api_key"}},
			commands: [
				"sudo apt-get install python3 python3-requests -yq",
				".drone/scripts/publish.py"
			]
		}
	]
};

local userRepoPublish(package_name, tag, user_repo) = {
	name: user_repo + "-publish-" + tag,
	kind: "pipeline",
	type: "docker",
	trigger: {branch: [tag]},
	depends_on: [
		"build-and-publish-" + tag,
		"create-tag-" + tag
	],

	steps: [{
		name: package_name,
		image: "proget.hunterwittenborn.com/docker/makedeb/makedeb-alpha:ubuntu-focal",
		environment: {
			ssh_key: {from_secret: "ssh_key"},
			known_hosts: {from_secret: "known_hosts"},
			package_name: package_name,
			release_type: tag,
			target_repo: user_repo
		},

		commands: [
			"sudo apt-get install sudo openssh-client sed git jq -yq",
			".drone/scripts/user-repo.sh"
		]
	}]
};

local sendBuildNotification(tag) = {
	name: "send-build-notification-" + tag,
	kind: "pipeline",
	type: "docker",
	trigger: {
		branch: [tag],
		status: ["success", "failure"]
	},
	depends_on: [
		"create-tag-" + tag,
		"build-and-publish-" + tag,
		"mpr-publish-" + tag,
		"aur-publish-" + tag
	],
	steps: [{
		name: "send-notification",
		image: "proget.hunterwittenborn.com/docker/hwittenborn/drone-matrix",
		settings: {
			username: "drone",
			password: {from_secret: "matrix_api_key"},
			homeserver: "https://matrix.hunterwittenborn.com",
			room: "#makedeb-ci-logs:hunterwittenborn.com"
		}
	}]
};

[
	createTag("stable"),
	createTag("beta"),
	createTag("alpha"),

	buildAndPublish("makedeb-makepkg", "stable", "makedeb"),
	buildAndPublish("makedeb-makepkg-beta", "beta", "makedeb-beta"),
	buildAndPublish("makedeb-makepkg-alpha", "alpha", "makedeb-alpha"),

	userRepoPublish("makedeb-makepkg", "stable", "mpr"),
	userRepoPublish("makedeb-makepkg-beta", "beta", "mpr"),
	userRepoPublish("makedeb-makepkg-alpha", "alpha", "mpr"),

	userRepoPublish("makedeb-makepkg", "stable", "aur"),
	userRepoPublish("makedeb-makepkg-beta", "beta", "aur"),
	userRepoPublish("makedeb-makepkg-alpha", "alpha", "aur"),
	
	sendBuildNotification("stable"),
	sendBuildNotification("beta"),
	sendBuildNotification("alpha")
]
