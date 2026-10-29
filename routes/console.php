<?php
// SIP-IB | PIC: Anggota 4 | Lingkup: Wajib | Isi implementasi oleh PIC

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');
