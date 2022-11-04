<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{

    public function login(Request $request)
    {
        $url = $request->path();
        Log::info("Hit API $url [ " .  $request . " ]");

        $validator = Validator::make(
            $request->all(),
            [
                'username' => 'required|min:4',
                'password' => 'required|min:6'
            ],
            [
                'required'  => ':attribute harus diisi',
                'min'       => ':attribute minimal :min karakter',
            ]
        );

        if ($validator->fails()) {
            Log::error("Failed $url [ " . $validator->fails() . " ]");
            $resp = [
                'metadata' => [
                    'message' => $validator->errors()->first(),
                    'code'    => 422
                ]
            ];
            return response()->json($resp, 422);
            die();
        }

        $user = User::where('username', $request->username)->first();
        if ($user) {
            if (Hash::check($request->password, $user->password)) {
                $token = Auth::login($user);
                $resp = [
                    'response' => [
                        'token' => $token
                    ],
                    'metadata' => [
                        'message' => 'OK',
                        'code'    => 200
                    ]
                ];

                return response()->json($resp);
            }
        }
        return $this->invalidResponse();
    }

    private function invalidResponse()
    {
        $resp = [
            'metadata' => [
                'message' => 'Username Atau Password Tidak Sesuai',
                'code'    => 401
            ]
        ];

        return response()->json($resp, 401);
    }
}
