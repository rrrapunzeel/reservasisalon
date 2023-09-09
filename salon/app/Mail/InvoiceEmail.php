<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;


class InvoiceEmail extends Mailable
{
    use Queueable, SerializesModels;

    public $nama;
    public $orderId;
    public $items;
    public $pegawai;
    public $selectedDateTime;
    public $total;
    public $email;
    

       /**
     * Create a new message instance.
     *
     * @param  string  $orderId
     * @param  string  $selectedDateTime
     * @param  array  $formattedItems
     * @param  string  $email
     * @param  string|null  $pegawai
     * @param  string|null  $total
     * @param  string  $nama
     * @return void
     */
    public function __construct($orderId, $selectedDateTime, $items, $email, $pegawai, $total, $nama)
{
    $this->orderId = $orderId;
    $this->selectedDateTime = $selectedDateTime;
    $this->items = $items;
    $this->email = $email;
    $this->pegawai = $pegawai;
    $this->total = $total;
    $this->nama = $nama;
    
}

 /**
     * Build the message.
     *
     * @return $this
     */
public function build()
{
    \Log::info('Items Data in InvoiceEmail:', ['items' => $this->items]);



    return $this->from('jasminepratiwiputrii@gmail.com', 'Challista Beauty Salon')
                ->subject('Invoice for Reservation')
                ->view('emails.invoice')
                ->with([
                    'orderId' => $this->orderId,
                    'selectedDateTime' => $this->selectedDateTime,
                    'items' => $this->items,
                    'email' => $this->email,
                    'pegawai' => $this->pegawai,
                    'total' => $this->total,
                    'nama' => $this->nama,
                ]);
                
}


    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Invoice Reservasi',
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            view: 'emails.email_template',
        );
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [];
    }
}
