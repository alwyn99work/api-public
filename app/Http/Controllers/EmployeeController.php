<?php

namespace App\Http\Controllers;

use GuzzleHttp\Client;
use Illuminate\Support\Facades\Log;

class EmployeeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
    }

    public function fetchPublic()
    {
        $url = "http://localhost:8001/api_fe/list_employee";
        try {
            Log::error("Hit private API $url");

            $client = new Client();
            $res = $client->get($url);
            $code = $res->getStatusCode();
            $body = json_decode($res->getBody(), true);

            return response()->json(
                [
                    'code'      => $code,
                    'status'    => 'success',
                    'data'      => $body['data']
                ],
                $code
            );
        } catch (\Exception $e) {
            Log::error("Failed hit private API $url", [$e->getMessage()]);

            return response()->json(
                [
                    'code'      => 500,
                    'status'    => 'failed',
                    'data'      => $e->getMessage()
                ],
                500
            );
        }
    }
}
