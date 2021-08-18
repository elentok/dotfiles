/* global document */

document.querySelectorAll("input").forEach((input) => {
  if (!["text", "number", "email"].includes(input.type)) return;

  if (input.type === "text") {
    input.value = `Text Value for ${input.id}`;
  } else if (input.type === "number") {
    input.value = 123;
  } else if (input.type === "email") {
    input.value = "james@bond.com";
  }
});

document.querySelectorAll("textarea").forEach((textarea) => {
  if (textarea.value !== null) {
    textarea.value = `Text Value for ${textarea.id}`;
  }
});

document.querySelectorAll("select").forEach((select) => {
  if (select.value == null) {
    select.value = select.options[0].value;
  }
});
