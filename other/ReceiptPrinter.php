<?php

namespace charlieuki\ReceiptPrinter;

use charlieuki\ReceiptPrinter\Item as Item;
use charlieuki\ReceiptPrinter\Store as Store;
use Mike42\Escpos\Printer;
use Mike42\Escpos\CapabilityProfile;
use Mike42\Escpos\EscposImage;
use Mike42\Escpos\PrintConnectors\CupsPrintConnector;
use Mike42\Escpos\PrintConnectors\WindowsPrintConnector;
use Mike42\Escpos\PrintConnectors\NetworkPrintConnector;
use Mike42\Escpos\PrintConnectors\FilePrintConnector;

class ReceiptPrinter
{
    private $printer;
    private $logo;
    private $store;
    private $items;
    private $terapist;
    private $dated;
    private $timeexec;
    private $currency = 'Rp. ';
    private $subtotal = 0;
    private $tax_percentage = 10;
    private $tax = 0;
    private $grandtotal = 0;
    private $request_amount = 0;
    private $qr_code = [];
    private $transaction_id = '';
    private $operator = '';
    private $customer_name = '';
    private $room_name = '';
    private $total;
    private $total_payment;
    private $payment_type;

    function __construct() {
        $this->printer = null;
        $this->items = [];
        $this->terapist = [];
        $this->timeexec = [];
        $this->customer_name = '';
        $this->room_name = '';
        $this->operator = '';
        $this->dated = '';
        $this->total = 0;
        $this->total_payment  = 0;
        $this->payment_type = '';
    }

    public function init($connector_type, $connector_descriptor, $connector_port = 9100) {
        switch (strtolower($connector_type)) {
            case 'cups':
                $connector = new CupsPrintConnector($connector_descriptor);
                break;
            case 'windows':
                $connector = new WindowsPrintConnector($connector_descriptor);
                break;
            case 'network':
                $connector = new NetworkPrintConnector($connector_descriptor);
                break;
            default:
                $connector = new FilePrintConnector("php://stdout");
                break;
        }

        if ($connector) {
            // Load simple printer profile
            $profile = CapabilityProfile::load("default");
            // Connect to printer
            $this->printer = new Printer($connector, $profile);
        } else {
            throw new Exception('Invalid printer connector type. Accepted values are: cups');
        }
    }

    public function close() {
        if ($this->printer) {
            $this->printer->close();
        }
    }

    public function setStore($mid, $name, $address, $phone, $email, $website) {
        $this->store = new Store($mid, $name, $address, $phone, $email, $website);
    }

    public function setLogo($logo) {
        $this->logo = $logo;
    }

    public function setDated($dated) {
        $this->dated = $dated;
    }

    public function setCurrency($currency) {
        $this->currency = $currency;
    }

    public function setTotal($total) {
        $this->total = $total;
    }

    public function setTotalPayment($total_payment) {
        $this->total_payment = $total_payment;
    }

    public function setPaymentType($payment_type) {
        $this->payment_type = $payment_type;
    }

    public function addItem($name, $qty, $price, $type) {
        $item = new Item($name, $qty, $price, $type);
        $item->setCurrency($this->currency);
        
        $this->items[] = $item;
    }

    public function addTerapist($name) {
        $this->terapist[] = $name;
    }

    public function getTerapist(){
        return $this->terapist;
    }

    public function addTimeExec($te) {
        $this->timeexec[] = $te;
    }

    public function getTimeExec(){
        return $this->timeexec;
    }

    public function getTotal() {
        return $this->total;
    }

    public function getTotalPayment() {
        return $this->total_payment;
    }

    public function getPaymentType() {
        return $this->payment_type;
    }

    public function setRequestAmount($amount) {
        $this->request_amount = $amount;
    }

    public function setCustomerName($c_name){
        $this->customer_name = $c_name;
    }

    public function setRoomName($r_name){
        $this->room_name = $r_name;
    }

    public function setTax($tax) {
        $this->tax_percentage = $tax;
        
        if ($this->subtotal == 0) {
            $this->calculateSubtotal();
        }

        $this->tax = (int) $this->tax_percentage / 100 * (int) $this->subtotal;
    }

    public function calculateSubtotal() {
        $this->subtotal = 0;

        foreach ($this->items as $item) {
            $this->subtotal += (int) $item->getQty() * (int) $item->getPrice();
        }
    }

    public function calculateGrandTotal() {
        if ($this->subtotal == 0) {
            $this->calculateSubtotal();
        }

        $this->grandtotal = (int) $this->subtotal + (int) $this->tax;
    }

    public function setTransactionID($transaction_id) {
        $this->transaction_id = $transaction_id;
    }

    
    public function setOperator($op){
        $this->operator = $op;
    }

    public function setQRcode($content) {
        $this->qr_code = $content;
    }

    public function setTextSize($width = 1, $height = 1) {
        if ($this->printer) {
            $width = ($width >= 1 && $width <= 8) ? (int) $width : 1;
            $height = ($height >= 1 && $height <= 8) ? (int) $height : 1;
            $this->printer->setTextSize($width, $height);
        }
    }

    public function getPrintableQRcode() {
        return json_encode($this->qr_code);
    }

    public function getPrintableHeader($left_text, $right_text, $is_double_width = false) {
        $cols_width = $is_double_width ? 8 : 16;

        return str_pad($left_text, $cols_width) . str_pad($right_text, $cols_width, ' ', STR_PAD_LEFT);
    }

    public function getPrintableSummary($label, $value, $is_double_width = false) {
        $left_cols = $is_double_width ? 6 : 12;
        $right_cols = $is_double_width ? 10 : 20;

        $formatted_value = $this->currency . number_format($value, 0, ',', '.');

        return str_pad($label, $left_cols) . str_pad($formatted_value, $right_cols, ' ', STR_PAD_LEFT);
    }

    public function feed($feed = NULL) {
        $this->printer->feed($feed);
    }

    public function cut() {
        $this->printer->cut();
    }

    public function printDashedLine() {
        $line = '';

        for ($i = 0; $i < 32; $i++) {
            $line .= '-';
        }

        $this->printer->text($line);
    }

    public function printLogo() {
        if ($this->logo) {
            $image = EscposImage::load($this->logo, false);

            //$this->printer->feed();
            //$this->printer->bitImage($image);
            //$this->printer->feed();
        }
    }

    public function printQRcode() {
        if (!empty($this->qr_code)) {
            $this->printer->qrCode($this->getPrintableQRcode(), Printer::QR_ECLEVEL_L, 8);
        }
    }

    public function printReceipt($with_items = true) {
        if ($this->printer) {
            // Get total, subtotal, etc
            $subtotal = $this->getPrintableSummary('Subtotal', $this->subtotal);
            $tax = $this->getPrintableSummary('Tax', $this->tax);
            $total = $this->getPrintableSummary('TOTAL', $this->grandtotal, true);
            $header = $this->getPrintableHeader(
                'TID: ' . $this->transaction_id,
                ''
            );
            $footer = "Thank you for shopping!\n";
            // Init printer settings
            $this->printer->initialize();
            $this->printer->selectPrintMode();
            // Set margins
            $this->printer->setPrintLeftMargin(1);
            // Print receipt headers
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            // Print logo
            $this->printLogo();
            $this->printer->selectPrintMode(Printer::MODE_DOUBLE_WIDTH);
            $this->printer->feed(2);
            $this->printer->text("{$this->store->getName()}\n");
            $this->printer->selectPrintMode();
            $this->printer->text("{$this->store->getAddress()}\n");
            $this->printer->text($header . "\n");
            $this->printer->feed();
            // Print receipt title
            $this->printer->setEmphasis(true);
            $this->printer->text("RECEIPT\n");
            $this->printer->setEmphasis(false);
            $this->printer->feed();
            // Print items
            if ($with_items) {
                $this->printer->setJustification(Printer::JUSTIFY_LEFT);
                foreach ($this->items as $item) {
                    $this->printer->text($item);
                }
                $this->printer->feed();
            }
            // Print subtotal
            $this->printer->setEmphasis(true);
            $this->printer->text($subtotal);
            $this->printer->setEmphasis(false);
            $this->printer->feed();
            // Print tax
            $this->printer->text($tax);
            $this->printer->feed(2);
            // Print grand total
            $this->printer->selectPrintMode(Printer::MODE_DOUBLE_WIDTH);
            $this->printer->text($total);
            $this->printer->feed();
            $this->printer->selectPrintMode();
            // Print qr code
            $this->printQRcode();
            // Print receipt footer
            $this->printer->feed();
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text($footer);
            $this->printer->feed();
            // Print receipt date
            $this->printer->text(date('j F Y H:i:s'));
            $this->printer->feed(2);
            // Cut the receipt
            $this->printer->cut();
            $this->printer->close();
        } else {
            throw new Exception('Printer has not been initialized.');
        }
    }

    public function printReceiptSPK($with_items = true) {
        if ($this->printer) {
            // Get total, subtotal, etc
            //$subtotal = $this->getPrintableSummary('Subtotal', $this->subtotal);
            //$tax = $this->getPrintableSummary('Tax', $this->tax);
            //$total = $this->getPrintableSummary('TOTAL', $this->grandtotal, true);

            // Init printer settings
            $this->printer->initialize();
            $this->printer->selectPrintMode();
            // Set margins
            $this->printer->setPrintLeftMargin(1);
            // Print receipt headers
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            // Print logo
            $this->printLogo();
            $this->printer->selectPrintMode(Printer::MODE_DOUBLE_WIDTH);
            $this->printer->feed(2);
            $this->printer->text("{$this->store->getName()}\n");
            $this->printer->selectPrintMode();
            $this->printer->text("{$this->store->getAddress()}\n");
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text("-------------------------------\n");

            // Receipt Information
            $this->printer->setJustification(Printer::JUSTIFY_LEFT);
            $this->printer->text("Tgl.  : ".$this->dated. "\n");
            $this->printer->text("Tamu  : ".$this->customer_name. "\n");
            $this->printer->text("Terapist  : \n");
            for ($i=0;$i<count($this->terapist);$i++) {
                $this->printer->text(($i+1).". ".$this->terapist[$i]. "\n");
            }
            $this->printer->text("Ruang : ". $this->room_name. "\n");
            $this->printer->text("Kasir : ". $this->operator. "\n");

            // --------------------
            $this->printer->feed();
            // Print receipt title
            $this->printer->setEmphasis(true);
            $this->printer->text("No. : ".$this->transaction_id. "\n");
            $this->printer->setEmphasis(false);

            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text("==============================\n");
            // Print items
            if ($with_items) {
                $this->printer->setJustification(Printer::JUSTIFY_LEFT);
                $this->printer->text("Perawatan : \n");
                foreach ($this->items as $item) {
                    if($item->getPrice()!="1"){
                        $this->printer->text(str_pad($item->getName(), 16)."\n");
                        $this->printer->text(str_pad('x'.$item->getQty(), 16)."\n");
                    }
                }
                $this->printer->feed();

                $this->printer->text("Produk    : \n");
                $this->printer->setJustification(Printer::JUSTIFY_LEFT);
                foreach ($this->items as $item) {
                    if($item->getPrice()=="1"){
                        $this->printer->text($item);
                    }
                }

                $this->printer->text("Waktu Perawatan : \n");
                for ($i=0;$i<count($this->timeexec);$i++) {
                    $this->printer->text(($i+1).". ".$this->timeexec[$i]. "\n");
                }
                $this->printer->feed();
            }
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text("==============================\n");
            $this->printer->feed(1);
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text('Ttd Terapist     Ttd Konsumen ');
            $this->printer->feed(3);
            $this->printer->text("_____________    _____________\n");

            $this->printer->text('Printed at '.date('j-m-Y H:i'));
            $this->printer->feed(2);
            // Cut the receipt
            $this->printer->cut();
            $this->printer->close();
        } else {
            throw new Exception('Printer has not been initialized.');
        }
    }

    public function printReceiptInvoice($with_items = true) {
        if ($this->printer) {
            // Get total, subtotal, etc
            //$subtotal = $this->getPrintableSummary('Subtotal', $this->subtotal);
            //$tax = $this->getPrintableSummary('Tax', $this->tax);
            //$total = $this->getPrintableSummary('TOTAL', $this->grandtotal, true);

            // Init printer settings
            $this->printer->initialize();
            $this->printer->selectPrintMode();
            // Set margins
            $this->printer->setPrintLeftMargin(1);
            // Print receipt headers
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            // Print logo
            $this->printLogo();
            $this->printer->selectPrintMode(Printer::MODE_DOUBLE_WIDTH);
            $this->printer->feed(2);
            $this->printer->text("{$this->store->getName()}\n");
            $this->printer->selectPrintMode();
            $this->printer->text("{$this->store->getAddress()}\n");
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text("-------------------------------\n");

            // Receipt Information
            $this->printer->setJustification(Printer::JUSTIFY_LEFT);
            $this->printer->text("Tgl.  : ".$this->dated. "\n");
            $this->printer->text("Tamu  : ".$this->customer_name. "\n");
            $this->printer->text("Kasir : ". $this->operator. "\n");

            // --------------------
            $this->printer->feed();
            // Print receipt title
            $this->printer->setEmphasis(true);
            $this->printer->text("No. : ".$this->transaction_id. "\n");
            $this->printer->setEmphasis(false);
            
            $right_cols = 10;
            $left_cols = 21;

            $c_goods = 0;
            $c_services = 0;
            foreach ($this->items as $item) {
                if($item->getType()=="1"){
                    $c_goods++;
                }else if($item->getType()=="2"){
                    $c_services++;
                }
            }

            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text("==============================\n");
            // Print items
            if ($with_items) {
                $this->printer->setJustification(Printer::JUSTIFY_LEFT);
                
                if($c_services>0){
                    $this->printer->text("Perawatan : \n");
                    foreach ($this->items as $item) {
                        if($item->getType()!="1"){
                            $this->printer->text(str_pad($item->getName(), 16)."\n");

                            $item_price = number_format($item->getPrice(), 0, ',', '.');
                            $item_subtotal = number_format($item->getPrice() * $item->getQty(), 0, ',', '.');

                            $print_priceqty = str_pad($item_price . ' x ' . $item->getQty(), $left_cols);
                            $print_subtotal = str_pad($item_subtotal, $right_cols, ' ', STR_PAD_LEFT);  
                            $this->printer->text($print_priceqty.$print_subtotal);

                        }
                    }
                }

                $this->printer->feed();
                $this->printer->feed();

                if($c_goods>0){
                    $this->printer->text("Produk    : \n");
                    $this->printer->setJustification(Printer::JUSTIFY_LEFT);
                    foreach ($this->items as $item) {
                        if($item->getType()=="1"){
                            $this->printer->text(str_pad($item->getName(), 16)."\n");

                            $item_price = number_format($item->getPrice(), 0, ',', '.');
                            $item_subtotal = number_format($item->getPrice() * $item->getQty(), 0, ',', '.');

                            $print_priceqty = str_pad($item_price . ' x ' . $item->getQty(), $left_cols);
                            $print_subtotal = str_pad($item_subtotal, $right_cols, ' ', STR_PAD_LEFT);  
                            $this->printer->text($print_priceqty.$print_subtotal);
                        }
                    }

                    $this->printer->feed();
                }
            }
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text("==============================\n");

            // Total 
            $item_total_ = $this->currency . number_format($this->getTotal(), 0, ',', '.');

            $print_total_label = str_pad('TOTAL', $left_cols);
            $print_total = str_pad($item_total_, $right_cols, ' ', STR_PAD_LEFT);  
            $this->printer->text($print_total_label.$print_total);
            // End Total

            // Total Payment
            $item_total_payment_ = $this->currency . number_format($this->getTotalPayment(), 0, ',', '.');

            $print_total_payment_label = str_pad('PAYMENT ', $left_cols);
            $print_total_payment = str_pad($item_total_payment_, $right_cols, ' ', STR_PAD_LEFT);  
            $this->printer->text($print_total_payment_label.$print_total_payment);
            //  Total Payment
            $this->printer->feed();
            $this->printer->feed();
            // Payment Type
            $this->printer->setJustification(Printer::JUSTIFY_LEFT);
            $this->printer->text("Catatan : ");
            $this->printer->feed(1);
            $this->printer->text($this->getPaymentType());
            //  Payment Type


            $this->printer->feed();
            $this->printer->feed();
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text('Ttd Kasir         Ttd Konsumen ');
            $this->printer->feed(3);
            $this->printer->text("_____________    _____________\n");

            $this->printer->text('Printed at '.date('j-m-Y H:i'));
            $this->printer->feed(2);
            // Cut the receipt
            $this->printer->cut();
            $this->printer->close();
        } else {
            throw new Exception('Printer has not been initialized.');
        }
    }

    public function printRequest() {
        if ($this->printer) {
            // Get request amount
            $total = $this->getPrintableSummary('TOTAL', $this->request_amount, true);
            $header = $this->getPrintableHeader(
                'TID: ' . $this->transaction_id,
                ''
            );
            $footer = "This is not a proof of payment.\n";
            // Init printer settings
            $this->printer->initialize();
            $this->printer->feed();
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            // Print logo
            $this->printLogo();
            // Print receipt headers
            //$this->printer->selectPrintMode(Printer::MODE_DOUBLE_WIDTH);
            //$this->printer->text("U L T I P A Y\n");
            //$this->printer->feed();
            $this->printer->selectPrintMode();
            $this->printer->text("{$this->store->getName()}\n");
            $this->printer->text("{$this->store->getAddress()}\n");
            $this->printer->text($header . "\n");
            $this->printer->feed();
            // Print receipt title
            $this->printDashedLine();
            $this->printer->setEmphasis(true);
            $this->printer->text("PAYMENT REQUEST\n");
            $this->printer->setEmphasis(false);
            $this->printDashedLine();
            $this->printer->feed();
            // Print instruction
            $this->printer->text("Please scan the code below\nto make payment\n");
            $this->printer->feed();
            // Print qr code
            $this->printQRcode();
            $this->printer->feed();
            // Print grand total
            //$this->printer->selectPrintMode(Printer::MODE_DOUBLE_WIDTH);
            $this->printer->text($total . "\n");
            $this->printer->feed();
            $this->printer->selectPrintMode();
            // Print receipt footer
            $this->printer->feed();
            $this->printer->setJustification(Printer::JUSTIFY_CENTER);
            $this->printer->text($footer);
            $this->printer->feed();
            // Print receipt date
            $this->printer->text(date('j F Y H:i:s'));
            $this->printer->feed(2);
            // Cut the receipt
            $this->printer->cut();
            $this->printer->close();
        } else {
            throw new Exception('Printer has not been initialized.');
        }
    }
}