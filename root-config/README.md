# root-config

Create the initial directory with the following command:

```sh
npx create-single-spa --moduleType root-config --skipInstall --layout --typescript --packageManager npm --dir root-config --orgName project
```

Set up the directory with compatible SystemJS configuration:

```sh
cd root-config

# initialize for SystemJS
curl https://raw.githubusercontent.com/minidomo/microfrontend-notes/refs/heads/main/setup-root.sh | sh
```
