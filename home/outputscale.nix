{ config, ... }:
{
  home.file."nixos/config/niri/outputscale.hm.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      #focused output
      OUTPUT=$(niri msg --json focused-output | jq -r '.name')
      #current scale
      CURRENT=$(niri msg --json outputs | jq -r ".\"$OUTPUT\".logical.scale")
      #Step size
      STEP=0.25
      
      if [ "$1" == "up" ]; then
          NEW=$(echo "$CURRENT + $STEP" | bc)
      elif [ "$1" == "down" ]; then
          NEW=$(echo "$CURRENT - $STEP" | bc)
      fi
      
      niri msg output "$OUTPUT" scale "$NEW"
      notify-send -u low -t 500 -i video-display \
        "$NEW" \
	"Scale: $OUTPUT"
    '';
  };
}
