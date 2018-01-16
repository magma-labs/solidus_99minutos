# Solidus + 99 Minutos

This is an extension to integrate 99 Minutos shipping service into Solidus.

## Requirements

Once you create the 99 minutos shipping methods, please use the next values as carrier:
```ruby
  [type: "99", vehicle: "bicycle", title: "Bicicleta en menos de 99 minutos"] => 'expressBicycle',
  [type: "99", vehicle: "bike", title: "En menos de 99 minutos"] => 'expressBike',
  [type: "sameDay", vehicle: "mini", title: "Motocarro entrega mismo d\u00eda (Solicitando antes de las 12 hrs)"] => 'sameDayMini',
  [type: "sameDay", vehicle: "bike", title: "Entrega mismo d\u00eda (Solicitando antes de las 17 hrs)"] = 'sameDayBike',
  [type: "sameDay", vehicle: "bicycle", title: "Bicicleta entrega mismo d\u00eda (Solicitando antes de las 17 hrs)"] => 'sameDayBycicle'
```

## Installation

This goes in your `Gemfile`:
```ruby
  gem 'solidus_99minutos'
```

This goes in your terminal:
```ruby
  rails g solidus_99minutos:install
```

## Running tests

```ruby
rake
```