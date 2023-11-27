const ctx = document.getElementById("results");

// let jsonData = [
//   {
//     command: "c benchmark",
//     mean: 0.0013721227927721866,
//     stddev: 9.657995879025468e-5,
//     median: 0.001340402,
//     user: 0.0009086216834400744,
//     system: 0.0003683430924062215,
//     min: 0.00129709,
//     max: 0.002251793,
//     checkpoint: "1701045860-a3e2844",
//   },
//   {
//     command: "rust benchmark",
//     mean: 0.00138280251425943,
//     stddev: 9.846449275343139e-5,
//     median: 0.0013516350000000001,
//     user: 0.0009145671573137072,
//     system: 0.0003715165593376265,
//     min: 0.001302486,
//     max: 0.0026641010000000003,
//     checkpoint: "1701045860-a3e2844",
//   },

//   {
//     command: "c benchmark",
//     mean: 0.0013721227927721866,
//     stddev: 9.657995879025468e-5,
//     median: 0.001340402,
//     user: 0.0009086216834400744,
//     system: 0.0003683430924062215,
//     min: 0.00129709,
//     max: 0.002251793,
//     checkpoint: "1701045880-a3e2845",
//   },
//   {
//     command: "rust benchmark",
//     mean: 0.00138280251425943,
//     stddev: 9.846449275343139e-5,
//     median: 0.0013516350000000001,
//     user: 0.0009145671573137072,
//     system: 0.0003715165593376265,
//     min: 0.001302486,
//     max: 0.0026641010000000003,
//     checkpoint: "1701045880-a3e2845",
//   },
// ];

function parseData(jsonData) {
  // function parseData(jsonData: { command: str, mean: number, checkpoint: str }[]) {
  let key = "mean";

  jsonData.sort((value1, value2) => {
    return value1.checkpoint.localeCompare(value2.checkpoint);
  });

  let labels = jsonData.map((inner) => inner.checkpoint);
  const uniqueLabels = [...new Set(labels)].sort().map((value) => {
    return value.split("-")[1];
  });

  const datasets = Object.entries(
    jsonData.reduce((result, value) => {
      let name = value["command"];

      value["checkpoint"] = value["checkpoint"].split("-")[1];

      if (!result[name]) {
        result[name] = [];
      }

      result[name].push(value);

      return result;
    }, {}),
  ).map((value) => {
    return {
      label: value[0],
      data: value[1],
      pointRadius: 10,
      pointHoverRadius: 8,
      parsing: {
        yAxisKey: key,
        xAxisKey: "checkpoint",
      },
    };
  });

  return {
    type: "line",
    data: {
      labels: uniqueLabels,
      datasets,
    },
    options: {
      parsing: {
        xAxisKey: "checkpoint",
        yAxisKey: key,
      },
      scales: {
        y: {
          ticks: {
            callback: function(value, index, ticks) {
              return "" + value + "s";
            },
          },
        },
      },
    },
  };
}

// new Chart(ctx, parseData(jsonData));

document.addEventListener("DOMContentLoaded", async () => {
  try {
    // Fetch JSON data asynchronously
    const response = await fetch("results.json");

    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    const jsonData = await response.json();

    const parsedData = parseData(jsonData);

    new Chart(ctx, parsedData);

    // Now you can use the jsonData variable as needed
    console.log("JSON Data:", jsonData);
  } catch (error) {
    console.error("Error fetching or parsing JSON:", error);
  }
});
