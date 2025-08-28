# martingale calculator

## build

set version;

```
$ENV:build_vsn='0.2.0'
```

build web:

```
flutter build web --build-name $ENV:build_vsn --dart-define vsn=$ENV:build_vsn --output public
```