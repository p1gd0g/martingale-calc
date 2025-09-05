# martingale calculator

## build

set version;

```
$ENV:build_vsn='0.3.0'
```

build web:

```
flutter build web --build-name $ENV:build_vsn --dart-define vsn=$ENV:build_vsn --output public
```

## math

x = current_position

x * current_price = notional_value
imr = notional_value / leverage
average_price = total_notional_value / total_position
next_price = (next_average_price) * (1 - decrease)
mmr = (current_price - next_price) * (total_position + x)
margin = imr + mmr = last_margin * 1.1
next_average_price = (total_notional_value + current_price * x) / (total_position + x)

