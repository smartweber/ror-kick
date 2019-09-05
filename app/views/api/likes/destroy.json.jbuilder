if @errors
  json.errors @errors
else
  json.message @message
end
