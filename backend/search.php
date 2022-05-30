<?php
class Search
{
  function grepSearchResults(DOMNode $domNode, array &$output)
  {
    foreach ($domNode->childNodes as $node) {
      if ($node->nodeName === 'a' && $node->parentNode->tagName === 'h2') {
        $nodeMap = $node->attributes;
        $href = $nodeMap->getNamedItem('href');

        $item = ['title' => $node->nodeValue, 'href' => $href->value];
        if (in_array($item, $output)) {
          print "in already";
        } else {
          $output[] = $item;
          //print 'added ' . json_encode($item) . '\n';
        }
      } else {
        if ($node->hasChildNodes()) {
          $val = $this->grepSearchResults($node, $output);
        }
      }
    }
  }

  public function search($name)
  {
    $name = str_replace('/\s+/', '-', $name);
    $name = preg_replace('/\(|\)/','',$name);
    
    $URL = 'https://kiertokaari.fi/?s=' . $name;

    $contents = file_get_contents($URL);
    error_log('encoding is: ' . mb_detect_encoding($contents));
    if ($contents) {
      $doc = new DOMDocument();
      libxml_use_internal_errors(true);
      $doc->loadHTML($contents);
      $output = [];
      $this->grepSearchResults($doc, $output);
      return $output;
    } else {
      return ['error' => "Ei tuloksia"];
    }
  }
}