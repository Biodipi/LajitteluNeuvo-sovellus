<?php

require('../vendor/autoload.php');
require '../search.php';
require '../alldetails.php';

use Symfony\Component\HttpFoundation\Request;

$app = new Silex\Application();
$app['debug'] = true;

// Register the monolog logging service
$app->register(new Silex\Provider\MonologServiceProvider(), array(
  'monolog.logfile' => 'php://stderr',
));

// Register view rendering
$app->register(new Silex\Provider\TwigServiceProvider(), array(
    'twig.path' => __DIR__.'/views',
));


// Our web handlers

// haku
$app->get('/search/{name}', function ($name) use ($app) {
  $search = new Search();
  $searchout = $search->search($app->escape($name));
  $output = $searchout;
  return $app->json($output, 200);
});

// details
$app->get('/details/{name}', function ($name) use ($app) {
  $details = new AllDetails();
  $detailsout = $details->search($app->escape($name));
    return $app->json($detailsout, 200);
});

$app->run();