# simple scrape

example urls

https://polar-mesa-94060.herokuapp.com/search/pakastin
->
```
[
    {
        "title": "Pakastin",
        "href": "https://kiertokaari.fi/jate/pakastin/"
    }
]
```

https://polar-mesa-94060.herokuapp.com/details?href=https://kiertokaari.fi/jate/pakastin/
->
```
{
    "result": "<h1>Pakastin</h1><p>Sähkölaitteista puretaan hallitusti osat, jotka sisältävät vaarallisia aineita. Muutoin sähkölaitteiden materiaalit ja osat käytetään uudelleen teollisuuden raaka-aineena.</p><p>Jäteasemille maksimissaan kolme isoa laitetta kerrallaan.</p><p>Otamme vastaan kaikissa vastaanottopisteissämme kotitalouslaitteisiin rinnastettavia laitteita kodeista ja yrityksistä.</p><p>Pieniä sähkölaitteita (ulkomitoista mikään ei ylitä 25 cm) voi palauttaa myös vähintään 1 000 m2 kokoiseen sähkölaitteita myyvään päivittäistavarakauppaan ja vähintään 200 m2 kokoiseen sähkölaitteita myyvään erikoiskauppaan. Lähimmän vastaanottopisteen löydät osoitteesta www.kierratys.info.  </p><p>Voit kierrättää datalaitteita myös maksullisen palvelun kautta www.seiffi.fi.</p>"
}
```


## Deploying

Install the [Heroku Toolbelt](https://toolbelt.heroku.com/).

```sh
$ git clone git@github.com:heroku/php-getting-started.git # or clone your own fork
$ cd php-getting-started
$ heroku create
$ git push heroku main
$ heroku open
```

or

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Documentation

For more information about using PHP on Heroku, see these Dev Center articles:

- [Getting Started with PHP on Heroku](https://devcenter.heroku.com/articles/getting-started-with-php)
- [PHP on Heroku](https://devcenter.heroku.com/categories/php)


