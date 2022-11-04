<?php

/** @var \Laravel\Lumen\Routing\Router $router */

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return $router->app->version();
});

$router->get('/ping', function () use ($router) {
    return "running...";
});

$router->post('/login', 'AuthController@login');

$router->get('/api_fe/list_employee', [
    'middleware' => 'auth',
    'uses'  => 'EmployeeController@fetchPublic'
]);
