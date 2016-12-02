I ran the script in the directory above which dumps the frames as pngs to this
directory. Then I ran:

```
ffmpeg -framerate 60 -i %04d.png -c:v libx264 -r 30 -pix_fmt yuv420p out.mp4
```

to stitch them into a movie.
