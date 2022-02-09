#!/usr/bin/env bash
set -euo pipefail

cat << EOF > nats.conf
port: 4333
websocket: {
  port: 9333
  no_tls: true
  compression: true
}
EOF

mkdir -p natsws-plain

ROOT=$(pwd)

cd "$(pwd)/natsws-plain"
npm init -y
npm install nats.ws


cat << EOF > index.js
import { connect } from "nats.ws";

const nc = await connect({servers: ["localhost:4333"]});
console.log("connected", nc.getServer());
EOF


cd "${ROOT}"


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


