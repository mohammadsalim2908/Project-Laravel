<?php
// SIP-IB | PIC: Anggota 4 | Lingkup: Wajib | Isi implementasi oleh PIC

use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});
