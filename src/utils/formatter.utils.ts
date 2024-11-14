export function removeSpecialCharactersAndSpaces(string: string) {
  return string.replace(/[^\w]/g, '');
}
