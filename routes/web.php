<?php
// SIP-IB | PIC: Anggota 4 | Lingkup: Wajib | Isi implementasi oleh PIC

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});
