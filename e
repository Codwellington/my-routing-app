import React, { useState, useRef, useEffect } from "react";
import { Button } from "@/components/ui/button"; // If you don't have this, replace with a standard button

const options = ["Serviced", "Misplaced", "Not Out"];

export default function CustomRectangles() {
  const [numRectangles, setNumRectangles] = useState(3);
  const [rectangles, setRectangles] = useState(
    Array.from({ length: numRectangles }, (_, i) => ({
      id: i + 1,
      name: `Rectangle ${i + 1}`,
      status: null,
    }))
  );
  const [currentIndex, setCurrentIndex] = useState(0);
  const rectangleRefs = useRef([]);

  useEffect(() => {
    if (rectangleRefs.current[currentIndex]) {
      rectangleRefs.current[currentIndex].scrollIntoView({
        behavior: "smooth",
        block: "center",
      });
    }
  }, [currentIndex]);

  useEffect(() => {
    if (rectangles.every((rect) => rect.status !== null)) {
      setTimeout(() => resetProgram(), 1000);
    }
  }, [rectangles]);

  const handleOptionClick = (option) => {
    const newRectangles = [...rectangles];
    newRectangles[currentIndex].status = option;
    setRectangles(newRectangles);
    if (currentIndex < rectangles.length - 1) {
      setCurrentIndex(currentIndex + 1);
    }
  };

  const resetProgram = () => {
    setCurrentIndex(0);
    setRectangles((prev) =>
      prev.map((rect, i) => ({
        id: i + 1,
        name: `Rectangle ${i + 1}`,
        status: null,
      }))
    );
  };

  const changeRectangleName = (index, newName) => {
    const newRectangles = [...rectangles];
    newRectangles[index].name = newName;
    setRectangles(newRectangles);
  };

  const updateNumRectangles = (num) => {
    setNumRectangles(num);
    setRectangles((prevRectangles) =>
      Array.from({ length: num }, (_, i) =>
        prevRectangles[i]
          ? prevRectangles[i]
          : { id: i + 1, name: `Rectangle ${i + 1}`, status: null }
      )
    );
    setCurrentIndex(0);
  };

  return (
    <div className="relative p-4">
      <button
        onClick={resetProgram}
        className="absolute top-4 right-4 bg-red-500 text-white rounded px-4 py-2"
      >
        Reset
      </button>

      <div className="mb-4">
        <label className="mr-2">Number of rectangles:</label>
        <input
          type="number"
          min="1"
          value={numRectangles}
          onChange={(e) => updateNumRectangles(Number(e.target.value))}
          className="p-2 border rounded"
        />
      </div>

      <div className="flex flex-col items-center gap-4">
        {rectangles.map((rect, index) => (
          <div
            key={rect.id}
            ref={(el) => (rectangleRefs.current[index] = el)}
            className={`w-96 h-32 flex flex-col items-center justify-center border-2 rounded-lg transition ${
              index === currentIndex ? "bg-blue-300" : "bg-gray-200"
            }`}
          >
            <input
              type="text"
              value={rect.name}
              onChange={(e) => changeRectangleName(index, e.target.value)}
              disabled={index !== currentIndex}
              className="mb-2 p-1 border rounded"
            />
            {index === currentIndex ? (
              <div className="flex flex-col items-center">
                <div className="flex gap-2 mt-2">
                  {options.map((option) => (
                    <button
                      key={option}
                      onClick={() => handleOptionClick(option)}
                      className="bg-green-500 text-white text-xs rounded px-2 py-1"
                    >
                      {option}
                    </button>
                  ))}
                </div>
                <button
                  onClick={() => handleOptionClick(\"Operator Error\")}
                  className=\"mt-2 bg-yellow-500 text-xs rounded px-2 py-1\"
                >
                  Operator Error
                </button>
              </div>
            ) : (
              <p>{rect.status || \"Pending\"}</p>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
