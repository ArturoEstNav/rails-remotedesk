//import 'js-autocomplete/auto-complete.css';
import autocomplete from 'js-autocomplete';

const autocompleteSearch = function() {
  console.log("Cargando autocomplete");
  const searchBox = document.getElementById('search-data')
  if (searchBox) {
    const skills = JSON.parse(document.getElementById('search-data').dataset.skills)
    const searchInput = document.getElementById('q');
    if (skills && searchInput) {
      new autocomplete({
        selector: searchInput,
        minChars: 1,
        source: function(term, suggest){
            term = term.toLowerCase();
            const choices = skills;
            const matches = [];
            for (let i = 0; i < choices.length; i++)
                if (~choices[i].toLowerCase().indexOf(term)) matches.push(choices[i]);
            suggest(matches);
        },
      });
    }
  }
};

export { autocompleteSearch };
