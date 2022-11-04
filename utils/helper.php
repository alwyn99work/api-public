<?php

if (!function_exists('LogRequest')) {
    function LogRequest($message)
    {
        \Illuminate\Support\Facades\Log::info("$message");
    }
}
