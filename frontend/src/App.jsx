import { useState, useEffect } from 'react'

let matrix = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0],
  [0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0],
  [0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0],
  [0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0],
  [0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0],
  [0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0],
  [0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0],
  [0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0],
  [0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0],
  [0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0],
  [0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0],
  [0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
];

function App() {
  const [posX, setPosX] = useState(8);  
  const [posY, setPosY] = useState(6);

  useEffect(() => {
    const interval = setInterval(() => {
      fetch("http://localhost:8000/run")
        .then(res => res.json())
        .then(data => {
          if (data.agents && data.agents.length > 0) {
            const firstAgent = data.agents[0];
            setPosX(firstAgent.pos[0]);
            setPosY(firstAgent.pos[1]);
          }
        })
        .catch(error => console.error("Error:", error));
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div>
      <h1>Pac-Man Simulation</h1>
      <svg width="800" height="500" xmlns="http://www.w3.org/2000/svg">
        {matrix.map((row, rowIdx) =>
          row.map((value, colIdx) => (
            <rect 
              key={`${rowIdx}-${colIdx}`}
              x={25 * colIdx} 
              y={25 * rowIdx} 
              width={25} 
              height={25} 
              fill={value === 1 ? "lightgray" : "gray"}/>

          ))
        )}
        <image 
          x={25 * posX} 
          y={25 * posY} 
          href="/ghost.png"
          width="20"
          height="20"
        />
      </svg>
    </div>
  );
}

export default App;