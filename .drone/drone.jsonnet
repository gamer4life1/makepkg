local createTag(branch) = {
	name: "create-tag-" + branch,
	kind: "pipeline",
	type: "docker",
	trigger: {branch: [branch]},

	steps: [{
		name: branch,
		image: "proget.hunterwittenborn.com/docker/hunter/makedeb:stable",
		environment: {
			release_type: branch,
			ssh_key: {from_secret: "ssh_key"},
			known_hosts: {from_secret: "known_hosts"}
		},

		commands: [".drone/scripts/create_tag.sh"]
	}]
};

local publishAptRepository(branch) = {
	name: "publish-apt-repo-" + branch,
	kind: "pipeline",
	type: "docker",
	trigger: {branch: [branch]},
	depends_on: ["create-tag-" + branch],

	steps: [
		{
			name: "build",
			image: "proget.hunterwittenborn.com/docker/hunter/makedeb:stable",
			environment: {branch: branch},
			commands: [".drone/scripts/apt.sh build"]
		},

		{
			name: "publish",
			image: "proget.hunterwittenborn.com/docker/hunter/makedeb:stable",
			environment: {proget_api_key: {from_secret: "proget_api_key"}},
			commands: [".drone/scripts/apt.sh publish"]
		}
	]
};

local userRepoPublish(package_name, branch, repo_name) = {
	name: repo_name + "-publish-" + branch,
	kind: "pipeline",
	type: "docker",
	trigger: {branch: [branch]},
	depends_on: [
		"create-tag-" + branch,
		"publish-apt-repo-" + branch
	],

	steps: [{
		name: branch,
		image: "proget.hunterwittenborn.com/docker/hunter/makedeb:stable",
		environment: {
			ssh_key: {from_secret: "ssh_key"},
			known_hosts: {from_secret: "known_hosts"},
			package_name: package_name,
			release_type: branch,
			target_repo: repo_name
		},

		commands: [".drone/scripts/user-repo.sh"]
	}]
};

[
	createTag("stable"),
	createTag("beta"),
	createTag("alpha"),

	publishAptRepository("stable"),
	publishAptRepository("beta"),
	publishAptRepository("alpha"),

	userRepoPublish("makedeb-makepkg", "stable", "mpr"),
	userRepoPublish("makedeb-makepkg-beta", "beta", "mpr"),
	userRepoPublish("makedeb-makepkg-alpha", "alpha", "mpr"),

	// userRepoPublish("makedeb-makepkg", "stable", "aur"),
	// userRepoPublish("makedeb-makepkg-beta", "beta", "aur"),
	// userRepoPublish("makedeb-makepkg-alpha", "alpha", "aur")

]
