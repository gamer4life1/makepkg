local publishAptRepository(branch) = {
	name: "publish-apt-repo-" + branch,
	kind: "pipeline",
	type: "docker",
	trigger: {branch: [branch]},

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

[
	publishAptRepository("stable"),
	publishAptRepository("beta"),
	publishAptRepository("alpha")
]
