immature(X):- adult(X), !, fail. 
immature(_X). 
% Red Cut. Sem o cut, caso adult() passe -> 1o immature() falhe, o sistema vai passar à 2a clausula e vai fazer com que o immature() troque o seu valor - sem o cut, o immature vai ser sempre true.
% Com o cut, quando adult() falha, passa à segunda clausula e retorna true, e quando o adult() passa, o cut ativa e a segunda clausula ja nao é acionada.

adult(X):- person(X), !, age(X, N), N >=18. 
adult(X):- turtle(X), !, age(X, N), N >=50. 
adult(X):- spider(X), !, age(X, N), N>=1. 
adult(X):- bat(X), !, age(X, N), N >=5. 
% Green Cuts. O cut neste caso, usa-se para melhorar a eficiencia - se X é person, não vale a pena verificar as outras funçoes.