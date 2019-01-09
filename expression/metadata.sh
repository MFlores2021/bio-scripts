
echo "#organism
organism_species: Citrus sinensis
organism_variety: 
organism_description: This organism is known as sweet orange as well
# organism - end

#project
project_name: Citrus sinensis v2.0 (HZAU)
project_contact: 
project_description: Data was downloaded from the Citrus sinensis Annotation Project website
index_dir_name: csinensisV2_index
expr_unit: TPM
ordinal: 10
# project - end

"
cube=100
img=100

# for i in `seq 1 10`;
# do 
while IFS='' read -r line || [[ -n "$line" ]]; do
set `eval echo $line`
tissue=$2
stage=$1
im_tissue=$4
im_stage=$3

echo "# figure --- All info needed for a cluster of images (usually includes a stage and all its tissues). Copy this block as many times as you need (including as many tissue layer blocks as you need).
figure_name: "$stage"_"$tissue"
cube_stage_name: "$tissue"
conditions: 

# write figure metadata

#tissue layer
layer_name: "$stage"
layer_description:
layer_type: stage
bg_color: #dfb6ed
layer_image: "$im_stage"
image_width: 280
image_height: 250
cube_ordinal: "$cube"
img_ordinal: "$img"
organ: "$tissue"
# layer - end

#stage layer
layer_name: "$tissue"
layer_description:
layer_type: tissue
bg_color:
layer_image: "$im_tissue"
image_width: 280
image_height: 250
cube_ordinal: "$cube"
img_ordinal: "$img"
organ: "$tissue"
# layer - end




# figure - end

"
cube=$((cube+10))
img=$((img+10))

done < ~/files.txt


