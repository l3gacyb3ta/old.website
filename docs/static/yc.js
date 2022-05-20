// Thanks a lot Aria <3! https://tacohitbox.com!

const getData = () => {
  fetch("https://yc.tacohitbox.com/api/last/l3gacyb3ta").then((response) => {
    response.json().then((data) => {
      document.getElementById("title").innerHTML = data.response.track.name;
      document.getElementById("artist").innerHTML =
        data.response.artist.name +
        " - " +
        (data.response["est-timestamp"] == "live"
          ? "listening now"
          : data.response["est-timestamp"]);

      document
        .getElementById("playlist")
        .setAttribute("src", data.response.cover);

      return;
    });
  });
};

getData();

if (!navigator.connection.saveData) {
  // Make sure we're not on a metered connection
  // run getData every 30 seconds
  setInterval(getData, 30000);
}
