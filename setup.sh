#!/usr/bin/env bash
set -euo pipefail

ROOT=$(pwd)

cat << EOF > nats.conf
port: 4333
websocket: {
  port: 9333
  no_tls: true
  compression: true
}
EOF

# npm install create-react-app serve

#mkdir -p natsws-plain
#

#
#cd "$(pwd)/natsws-plain"
#npm init -y
#npm install nats.ws
#
#
#cat << EOF > index.js
#import { connect } from "nats.ws";
#
#const nc = await connect({servers: ["localhost:4333"]});
#console.log("connected", nc.getServer());
#EOF
#
#
npx create-react-app natsws-react
cd "$(pwd)/natsws-react"
npm install nats.ws

cat << EOF > src/App.js
import React, { useEffect, useState } from "react";
import { connect } from "nats.ws";

function App() {
  const [msg, setMsg] = useState("");
  const [nc, setNc] = useState(null);

  useEffect(() => {
    if (!nc) {
      async function initialize() {
        try {
          console.log("initializing");
          const conn = await connect({
            servers: ["ws://localhost:9333"],
            debug: true,
            maxReconnectAttempts: 5,
          });
          setNc(conn);
          setMsg("connected to " + conn.getServer());
        } catch (err) {
          setMsg("failed to connect: " + err.message);
        }
      }
      initialize();
    }
  }, [nc]);
  return <h1>{msg}</h1>;
}

export default App;
EOF
#
#cd "${ROOT}"
#npm uninstall -g create-react-app
#npx clear-npx-cache
#npm install -g create-react-app@4.0.3
#
#mkdir -p "old-react"
#cd "$(pwd)/old-react"
#npm init -y
#npm install create-react-app@4.0.3
#
#npx create-react-app natsws-react-old
#cd natsws-react-old
#npm install nats.ws
#
#cat << EOF > src/App.js
#import React, { useEffect, useState } from "react";
#import { connect } from "nats.ws";
#
#function App() {
#  const [msg, setMsg] = useState("");
#  const [nc, setNc] = useState(null);
#
#  useEffect(() => {
#    if (!nc) {
#      async function initialize() {
#        try {
#          console.log("initializing");
#          const conn = await connect({
#            servers: ["ws://localhost:9333"],
#            debug: true,
#            maxReconnectAttempts: 5,
#          });
#          setNc(conn);
#          setMsg("connected to " + conn.getServer());
#        } catch (err) {
#          setMsg("failed to connect: " + err.message);
#        }
#      }
#      initialize();
#    }
#  }, [nc]);
#  return <h1>{msg}</h1>;
#}
#
#export default App;
#EOF
#
