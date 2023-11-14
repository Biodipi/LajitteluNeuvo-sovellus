# LajitteluNeuvo-sovellus

LajitteluNeuvo-sovelluksen avulla käyttäjät voivat tarkastella kätevästi, mitä jätteitä voi viedä hyötyjätteiden lajitteluasemalle. Sovelluksen avulla on helppo tarkastaa, onko esine vietävissä maksutta lajitteluasemalla vai onko se maksullinen jäte. Erilaisten esineiden palautuspisteet on sijoitettu tietylle paikoille lajitteluasemalla ja sovelluksen avulla käyttäjä voi myös suunnitella esineiden viennin sekä nähdä kartalla selkeästi erilaisten esineiden palautuspisteet. Näin asiakkaat voivat helposti suunnitella ja viedä esineitä hyötyjätteiden lajitteluasemalla, ja esineet päätyvät siellä myös oikeille paikoilleen, mikä vähentää myös lajitteluaseman työntekijöiden työmäärää.

## Sovelluksen toiminta

Sovelluksen avulla käyttäjä voi selata jäteopasta antamalla esineen nimen tai osan sitä hakukriteerinä. Tulos listaa jäteoppaan esineet.

![Etsintä](https://github.com/Biodibi/hyotyjate/blob/master/images/etsinta.png)

Valitsemalla listalta esineen voi tarkastella esineen tietoja. Esineestä näytetään mitä jätettä se on (esim. metalli), voiko sen palauttaa hyötyjätteiden lajitteluasemalle (maksuton jäte on palautettavissa) sekä osoitteen, missä lähin hyötyjätteiden lajitteluasema sijaitsee. 

![Tulos](https://github.com/Biodibi/hyotyjate/blob/master/images/tulos.png)

Painamalla Lisätietoa-painiketta voi tarkastella esineen lisätietoja.

![Lisätietoa](https://github.com/Biodibi/hyotyjate/blob/master/images/lisatietoa.png)

Painamalla Lisää tuotelistaan -painiketta tuote lisätään listalle, jonka mukaiset esineet käyttäjä aikoo palauttaa hyötyjätteiden lajitteluasemalle.

![Listaus](https://github.com/Biodibi/hyotyjate/blob/master/images/lista.png)

Mikäli tuote ei ole palautettavissa hyötyjätteiden lajitteluasemalle, sitä ei voi lisätä listalle

![Ei voi palauttaa](https://github.com/Biodibi/hyotyjate/blob/master/images/eivoipalauttaa.png)

Kun jätteitä lähdetään viemään lajitteluasemalle, näytetään pohjapiirros, joka osoittaa esineiden palautuspisteet.

![Kartta](https://github.com/Biodibi/hyotyjate/blob/master/images/kartta.png)

Esineen voi kuitata jätetyksi ja merkitä palautustapahtuman päättyneeksi.

![Kuittaus](https://github.com/Biodibi/hyotyjate/blob/master/images/kuittaus.png)

Käyttäjällä on mahdollista antaa palautetta sovelluksen toiminnasta esineiden palautuksen jälkeen.

![Palaute](https://github.com/Biodibi/hyotyjate/blob/master/images/palaute.png)

## Sovelluksen toteutuksessa käytetyt tekniikat

Sovellus on toteutettu [Flutterilla](https://flutter.dev). Palautteet tallennetaan [Firebaseen](https://firebase.google.com). Demossa jätteiden tiedot haetaan [Kiertokaaren](https://kiertokaari.fi) web-sivuilta verkkoharavointi (web scraper)-tekniikalla.

## Lisenssi

Tämän projektin lähdekoodi on lisenssoitu MIT-lisenssillä. Katso lisenssin tiedot tarkemmin [LICENSE](https://github.com/Biodibi/hyotyjate/blob/master/LICENSE.md) tiedostosta. Mikäli sovelluksessa on käytetty kolmannen osapuolen työkaluja, komponentteja tai vastaavia, noudetaan niiden osalta ilmoitettuja lisenssiehtoja

