#!/usr/bin/sh

#Take the necessary inputs

echo "Enter the name of the input file: "
read input_file

echo "Enter startup delay of the tracking(with signs): "
read startup_delay

echo "Enter the transperency to be applied(between 0.0 and 1.0): "
read alpha

echo "Enter the the name of the output file(with file extension): "
read output_file

# Get the negetive of the image

ffmpeg -i "$input_file" -vf negate inverted_file.mp4 -y

# Overlay it with a specific opacity

ffmpeg \
    -i "$input_file" -i inverted_file.mp4 \
    -filter_complex " \
        [0:v]setpts=PTS-STARTPTS, scale=480x360[top]; \
        [1:v]setpts=PTS-STARTPTS"$startup_delay"/TB, scale=480x360, \
             format=yuva420p,colorchannelmixer=aa="$alpha"[bottom]; \
        [top][bottom]overlay=shortest=1" \
    -c:v libx264 -c:a aac "$output_file" -y

# Delete the inverted file

rm "$inverted_file"
