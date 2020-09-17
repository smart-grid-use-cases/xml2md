owner_url=$1
repo_name=$2
file_request=$3
destination=$4
latest_url=$(wget https://github.com/${owner_url}/${repo_name}/releases/latest --max-redirect=0 2>&1 | grep Location)
prefix="Location: https://github.com/${owner_url}/${repo_name}/releases/tag/"
suffix=" [following]"
tail=${latest_url#"$prefix"}
release_version=${tail%"$suffix"}
echo "Release version: $release_version"
if [ -z "${file_request}" ]
then
    exit 0
else
    wget -q https://github.com/${owner_url}/${repo_name}/releases/download/${release_version}/${file_request}
    unzip -q $file_request -d $destination
    rm $file_request
    exit 0
fi
