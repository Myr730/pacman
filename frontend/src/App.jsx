import { useState } from 'react'

const App = () => {
  const [posX, setPosX] = useState(6);
  const [posY, setPosY] = useState(8);
  
    useEffect(() => {
    const interval = setInterval(() => {
      fetch("http://localhost:8000/run")
      .then(res => res.json())
      .then(res => {
        setPosX(res.agents[0].pos[0]-1);
        setPosX(res.agents[0].pos[1]-1);
      });
    }, 1000);

      return () => clearInterval(interval);
  }, [posX, posY]);

  return (
    <div>
      <svg width="800" height="500" style={{backgroundColor: "lightgray"}} xmlns="http://www.w3.org/2000/svg">
           <image 
          x={100 + 10 * posX} 
          y={9 + 25 * posY} 
          href="ghost.png"
          width="40"    
          height="40"   
        />
      </svg>
    </div>
  );
};


export default App;