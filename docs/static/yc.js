// Thanks a lot Aria! https://tacohitbox.com!

const title = document.getElementById("title");
const artist = document.getElementById("artist");
const playlist = document.getElementById("playlist");

const getData = () => {
  fetch("https://yc.tacohitbox.com/api/last/l3gacyb3ta").then((response) => {
    response.json().then((data) => {
      const track = data.response.track;
      const cover = data.response.cover;

      title.innerHTML = track.name;
      artist.innerHTML =
        data.response.artist.name +
        " - " +
        (data.response["est-timestamp"] == "live"
          ? "listening now"
          : data.response["est-timestamp"]);

      playlist.setAttribute("src", cover);

      return;
    });
  });
};

getData();

if (!navigator.connection.saveData) { // Make sure we're not on a metered connection
  // run getData every 30 seconds
  setInterval(getData, 30000);
}
