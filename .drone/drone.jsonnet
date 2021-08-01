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
			commands: [".drone/scripts/apt.sh publish"]
		}
	]
};

[
	publishAptRepository("stable"),
	publishAptRepository("beta"),
	publishAptRepository("alpha")
]
