```sh
# making root config
npx create-single-spa

# in root config
npm un husky pretty-quick
rm -rf .husky .git

npm update --save
npm i single-spa@latest single-spa-layout@latest
npm i @types/node@22 -D
```