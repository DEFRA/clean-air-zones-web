export default function(name, value) {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = name;
    input.value = value.replace(/\s/g, "").toUpperCase();
    return input;
};
