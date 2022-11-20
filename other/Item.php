<?php

namespace charlieuki\ReceiptPrinter;

class Item
{
    private $name;
    private $qty;
    private $price;
    private $type; // 1 Goods 2 Services
    private $currency = 'Rp. ';

    function __construct($name, $qty, $price, $type) {
        $this->name = $name;
        $this->qty = $qty;
        $this->price = $price;
        $this->type = $type;
    }

    public function setCurrency($currency) {
        $this->currency = $currency;
    }

    public function getQty() {
        return $this->qty;
    }

    public function getName() {
        return $this->name;
    }

    public function getPrice() {
        return $this->price;
    }

    public function getType() {
        return $this->type;
    }

    public function __toString()
    {
        $right_cols = 10;
        $left_cols = 21;

        $item_price = $this->currency . number_format($this->price, 0, ',', '.');
        $item_subtotal = $this->currency . number_format($this->price * $this->qty, 0, ',', '.');
        
        $print_name = str_pad($this->name, 16) ;
        $print_priceqty = str_pad($item_price . ' x ' . $this->qty, $left_cols);
        $print_subtotal = str_pad($item_subtotal, $right_cols, ' ', STR_PAD_LEFT);

        return "$print_name\n$print_priceqty$print_subtotal\n";
    }
}