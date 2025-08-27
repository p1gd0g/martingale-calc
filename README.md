# martingale calculator

## build

通过环境变量设置版本号

```
$ENV:build_vsn='0.1.0'
```

打包 web

```
flutter build web --build-name $ENV:build_vsn --dart-define vsn=$ENV:build_vsn --output public
```