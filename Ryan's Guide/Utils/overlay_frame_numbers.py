import ffmpeg

input_files = ['insert video path']
output_files = ['insert video path']                                                                                 
                                                                                  


for input_file, output_file in zip(input_files, output_files):                   
    (                                                                            
        ffmpeg
        .input(input_file)
        .output(output_file, vf="drawtext=fontfile=Arial.ttf: text='%{n}': x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000099")
        .run()
    )