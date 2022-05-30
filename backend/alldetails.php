<?php
class AllDetails
{
  function grepSearchResults(DOMNode $domNode, array &$output)
  {
    foreach ($domNode->childNodes as $node) {
      if ($node->nodeName === 'h1') {
        $nodeMap = $node->attributes;

        $paperi = 'Aikakauslehdet, Kirjekuori, Kirja (kannet poistettu), Mainokset, Puhelinluettelo, Paperisäkki, Paperisilppu, 
        Paperikassi (valkoinen), Paperi, Sanomalehti, Uusiopaperi';

        $kasittelematonpuu = 'Lava, Puujäte (käsittelemätön)';

        $pahvijakartonki = 'Aaltopahvi (pieni määrä), Aaltopahvi (suuri määrä), Käärepaperi (voimapaperi), Konvehtirasia (kartonki),
        Kertakäyttöastia (kartonkia), Kartonkipakkaus, Kananmunakenno (kartonkia), Lääkepakkaus (kartonkia),
        Lahjapakkaus (kartonkia), Paperikassi (ruskea), Voimapaperi';

        $metalli = 'Autonosat (metallia), Aterimet (metalliset), Ankkuri, Alumiini (esim. viilipurkin kansi), 
        Aerosolipullo (tyhjä, ei hölsky eikä pihise), Elintarvikepakkaus (metallia), Grilli, Folio, 
        Hautakynttilä (metallinen kansi), Harava (metallinen piikkiosa), Juomatölkki (pantiton) 
        Jarrulevy, Kylpyamme (metallia), Kuokka, Kirves, Keittiövälineet (metalli), Kattopelti, Kattila,
        Katiska, Kaasuhella, Lämpökynttilä (metalliosa), Lukko, Lattiamoppi (metallivarsi), 
        Lastenvaunut (metalliosat), Lapio (metallia), Moottorisaha, Moottori, Metallisanko,
        Metalliromu, Metallipannu, Metallipakkaus (tyhjä), Maalipurkki (tyhjä, metallinen), Nitoja (metallia)
        Nestekaasusäiliö (tyhjä, metallinen), Naula, Ovenkahva (metallia), Pölykapseli (metallia),
        Pyykinkuivausteline (metallinen), Puutarhakaluste (metallia), Potkukelkka, Polkupyörä, Piikkilanka,
        Pienkone, polttomoottorikäyttöinen, Pesuvati (metalliset ja emaloidut), Pesuallas (metallia), Perämoottori,
        Pensassakset, Pelti, Partahöylä (metallia), Pakoputki, Paistinpannu, Ruokailuvälineet (metallia),
        Ruohonleikkuri (käsikäyttöinen, polttomoottorikäyttöinen), Retkikeittimen poltin, Rei’ittäjä (metallia),
        Sänky (metallia), Säilyketölkki, Sytytin (metallinen, tyhjä), Sorvilastut (metallia), Silityslauta,
        Saunakiuas (puulämmitteinen), Sakset, Työkalu (metallia), TV-antenni, Tuulilasinpyyhkijä,
        Teräsromu, Termospullo (metallinen), Teflonastia, Uunivuoka (metallia), Urheiluvälineet (metalliset),
        Verhotanko (metalli), Valurauta, Vaijeri, Vaaka (metallinen)';

        $pienelektroniikka = 'Antennivahvistin, CD/DVD-soitin, Hiustenkuivaaja, Kello (sähköllä toimiva), Keittiökoneet,
        Kasettisoitin, Kamera, Lämpömittari (sähköllä toimiva), Lämpömittari (digitaalinen), Lelut (akku- ja paristokäyttöiset),
        Leivänpaahdin, LED-lamppu, MP3-soitin, Mikroaaltouuni, Matkapuhelin, Maalipurkki (sisältää nestemäistä maalia),
        Porakone, Parranajokone, Palovaroitin, Sähköjohto, Sähköhammasharja, Stereot, Sisätilanlämmitin,
        Silitysrauta, Työkalut (sähkökäyttöiset), Viivakoodinlukija, Videonauhuri, Vaaka (sähkökäyttöinen), Vaaka';

        $televisiot = 'Televisio';

        $lasipullot = 'Lääkepakkaus (lasinen), Lasipurkki, Lasipullo';

        $vanteelliset = 'Renkaat (kierrätysmaksu maksettu)';

        $vanteettomat = 'Vanteettomat renkaat';

        $suuretkodinkoneet = 'Aurinkopaneeli, Astianpesukone, Hella, Kiuaskivet, Lämminvesivaraaja, 
        Liesituuletin, Mankeli, Ompelukone, Pölynimuri, Pienkoneet (sähkökäyttöiset), Pesukone, Pakastin,
        Sähkösaha, Sähköruohonleikkuri, Sähköpatteri, Sähkökiuas, Saunakiuas (sähköllä toimiva), Yleiskone';

        $kylmalaitteet = 'Ilmalämpöpumppu, Jääkaappi, Pakastin';

        $tietotekniset = 'ATK-laitteet, Monitoimilaite';

        $valaisimet = 'Energiansäästölamppu, Infrapunavalaisin, Jouluvalot, Loisteputki, Taskulamppu, Valaisin';

        $muutvaaralliset = 'Autovaha, Asetoni, Akryyliväri, Akku (matkapuhelin, kamera, muut pienlaitteet), Akku (ajoneuvot), 
        Aerosolipullo (pihisee, hölskyy), Bitumi (juokseva), Bensiini, Diesel, Desinfiointiaine, Etanoli, Hydrauliikkaletku,
        Hajuvesipullo (sisältää nestettä), Iskunvaimennin, Jäähdytinneste, Jäteöljy, Jarruneste, Kytkinneste,
        Kynsilakka (nestemäinen), Konetiskiaine, Kenkälankki (sisältää vaarallisia aineita), Kemikaalit, Kasvinsuojeluaineet, 
        Kalkinpoistoaine, Liuotin, Liima (sisältää vaarallisia aineita), Lakka, Nestekaasusäiliö (täysi tai vajaa),
        Ohenne, Puuöljy, Puunsuoja- ja kyllästysaineet, Polttoöljy (kevyt), Paristo, Pakkasneste, Ruosteenestoaine,
        Rotanmyrkky, Sytytysneste, Sytytin (sis. ainetta), Suksivoide (sis. vaarallista ainetta), Siivouskemikaalit (sis. vaarallista ainetta),
        Tärpätti, Torjunta-aine, Tinneri, Tasoiteaine (sis. vaarallista ainetta), Tahranpoistoaine, Uuninpuhdistusaine,
        Uudenvuoden tina, Voiteluöljy, Viemärinaukaisuaine, Valokuvauskemikaalit, Öljyvärituubi, Öljynsuodatin, Öljyiset trasselit';
        
        $palautettava = $node->nodeValue;

        if(str_contains($paperi, $palautettava)){
          $output['wastetype']= 'Paperi';
          $output['id']= 1;}

        if(str_contains($kasittelematonpuu, $palautettava)){
          $output['wastetype']= 'Käsittelemätön puu';
          $output['id']= 2;}

        if(str_contains($pahvijakartonki, $palautettava)){
          $output['wastetype']= 'Pahvi ja kartonki';
          $output['id']= 6;}

        if(str_contains($metalli, $palautettava)){
          $output['wastetype']= 'Metalli';
          $output['id']= 9;}

        if(str_contains($pienelektroniikka, $palautettava)){
          $output['wastetype']= 'Pienelektroniikka';
          $output['id']= 11;}

        if(str_contains($televisiot, $palautettava)){
          $output['wastetype']= 'Televisiot';
          $output['id']= 12;}

        if(str_contains($lasipullot, $palautettava)){
          $output['wastetype']= 'Lasipullot ja purkit';
          $output['id']= 13;}

        if(str_contains($vanteelliset, $palautettava)){
          $output['wastetype']= 'Vanteelliset renkaat';
          $output['id']= 14;}

        if(str_contains($vanteettomat, $palautettava)){
          $output['wastetype']= 'Vanteettomat renkaat';
          $output['id']= 15;}

        if(str_contains($suuretkodinkoneet, $palautettava)){
          $output['wastetype']= 'Suuret kodinkoneet';
          $output['id']= 16;}

        if(str_contains($kylmalaitteet, $palautettava)){
          $output['wastetype']= 'Kylmälaitteet';
          $output['id']= 18;}

        if(str_contains($tietotekniset, $palautettava)){
          $output['wastetype']= 'Tietotekniset laitteet';
          $output['id']= 19;}

        if(str_contains($valaisimet, $palautettava)){
          $output['wastetype']= 'Valaisimet+lamput+data-ser';
          $output['id']= 20;}

        if(str_contains($muutvaaralliset, $palautettava)){
          $output['wastetype']= 'Muut vaaralliset jätteet';
          $output['id']= 11;}

      }
        if ($node->hasChildNodes()) {
          $val = $this->grepSearchResults($node, $output);
        }
      }
    
  
  
  
    foreach ($domNode->childNodes as $node) {

      if ($node->nodeName === 'h2') {
        $nodeMap = $node->attributes;
        $class = $nodeMap->getNamedItem('class');

        if (str_starts_with($class->value, 'heading-')) {
          if (str_contains($class->value, 'place')) {
            $place = true;
          }
        }
        if (str_starts_with($class->value, 'heading-')) {
          if (str_contains($class->value, 'price')) {
            $price = true;
          }
        }
        if (str_starts_with($class->value, 'heading-')) {
          if (str_contains($class->value, 'use')) {
            $use = true;
          }
        }
      }
    
      ///// PLACE

      if ($node->nodeName === 'ul' && $place) {
        $paikkatieto = $node->nodeValue;
        $place = false;
        if(str_contains($paikkatieto, 'Oivapiste')){
          $paikkaulos = true;
          $output['place']= $paikkaulos;}
          else {
          $paikkaulos = false;
          $output['place']= $paikkaulos;}
    }

      ///// PRICE

      if ($node->nodeName === 'ul' && $price) {
        $hintatieto = $node->nodeValue;
        $price = false;
        if(str_contains($hintatieto, 'maksuton')){
          $output['price']= false;
      } else{
        $output['price']= true;
      }
    }


      ///// USE

      if ($node->nodeName === 'p' && $use) {
        $output['use']= $node->nodeValue;
        $use = false;
      }

      ///// RESULTS
      
      if ($node->hasChildNodes()) {
        $this->grepSearchResults($node, $output);
      }
    }
  }

  public function search($name)
  {
    $name = preg_replace('/[áàãâä]/ui', 'a', $name);
    $name = preg_replace('/[éèêë]/ui', 'e', $name);
    $name = preg_replace('/[íìîï]/ui', 'i', $name);
    $name = preg_replace('/[óòõôö]/ui', 'o', $name);
    $name = preg_replace('/[úùûü]/ui', 'u', $name);
    $name = preg_replace('/[ç]/ui', 'c', $name);
    $name = preg_replace('/\s+/', '-', $name);
    $name = preg_replace('/\(|\)/','',$name);
    $URL = 'https://kiertokaari.fi/jate/' . $name;

    $contents = file_get_contents($URL);
    error_log('encoding is: ' . mb_detect_encoding($contents));
     {
      $contents = preg_replace('/(\v|\s)+/', ' ', $contents);
      $doc = new DOMDocument();
      libxml_use_internal_errors(true);
      $doc->loadHTML($contents);
      $output = [];
      $this->grepSearchResults($doc, $output);
      return $output;
    }
  }
}