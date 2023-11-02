#!/usr/bin/env -S bunx zx

$.verbose = false;

const month = process.argv[2]

console.log({month})
const { stdout } = await $`curl 'https://afspraak.utrecht.nl/qmaticwebbooking/rest/schedule/branches/6799b9a23eb23e3be8cff82b78da95d10503b9057b8cf48bc34c4bc47f0/dates;servicePublicId=2d7f771f9554b048625e837f7f0c8936b1993136558d7625d59c48846473c44d;customSlotLength=25' -H 'authority: afspraak.utrecht.nl' -H 'accept: application/json, text/plain, */*'`

const days = JSON.parse(stdout)
  .map(d => new Date(d.date))
  .filter(d => d.getMonth() === month)
  .map(d => d.getDate());

console.log(days)
