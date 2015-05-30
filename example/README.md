For building:

```
$ cd <example_dir>
$ dub
```

Run variants:

```
$ app --log trace
$ app --log info
$ app --log <name>:debug
$ app --log <name>.<subname>:warn
$ app --log-file=<filename>
$ app --log trace --log-console-color=false
```
