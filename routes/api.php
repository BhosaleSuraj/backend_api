<?php

use Illuminate\Support\Facades\Route;

Route::get('/test', function () {
    return response()->json([
        'message' => 'Backend is working 🚀'
    ]);
});
Route::get('/users', function () {
    return response()->json([
        ['id' => 1, 'name' => 'Suraj'],
        ['id' => 2, 'name' => 'John']
    ]);
});