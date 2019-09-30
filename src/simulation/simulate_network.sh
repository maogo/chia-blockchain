ps -e | grep python | grep "start_" | awk '{print $1}' | xargs -L1  kill -9
python -m src.server.start_plotter &
P1=$!
python -m src.server.start_timelord &
P2=$!
python -m src.server.start_farmer &
P3=$!
python -m src.server.start_full_node "127.0.0.1" 8002 "-f" "-t" &
P4=$!
python -m src.server.start_full_node "127.0.0.1" 8004 &
P5=$!
python -m src.server.start_full_node "127.0.0.1" 8005 &
P6=$!

_term() {
  echo "Caught SIGTERM signal, killing all servers."
  kill -TERM "$P1" 2>/dev/null
  kill -TERM "$P2" 2>/dev/null
  kill -TERM "$P3" 2>/dev/null
  kill -TERM "$P4" 2>/dev/null
  kill -TERM "$P5" 2>/dev/null
  kill -TERM "$P6" 2>/dev/null
}

trap _term SIGTERM
trap _term SIGINT
trap _term INT
wait $P1 $P2 $P3 $P4 $P5 $P6