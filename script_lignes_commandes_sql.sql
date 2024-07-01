use sakila;

-- Pour enlever le mode safe & pouvoir supprimer des lignes de table
-- SET SQL_SAFE_UPDATES = 0;

-- Selection des 5 premieres lignes de la table Acteur
select * from actor
Limit 5;

-- Récupérer dans une colonne Actor_Name le full_name des acteurs sous le format: first_name + "
-- " + last_name
select concat(first_name," ",last_name) as Actor_Name
from actor;

-- Récupérer dans une colonne Actor_Name le full_name des acteurs sous le format: first_name en
-- minuscule + "." + last_name en majuscule

select concat(LOWER(first_name),".",UPPER(last_name)) as Actor_Name
from actor;

-- Récupérer dans une colonne Actor_Name le full_name des acteurs sous le format: last_name en
-- majuscule + "." + premiere lettre du first_name en majuscule
select CONCAT(UPPER(last_name),".",
    CONCAT(
        UPPER(SUBSTRING(first_name,1,1)),
        LOWER(SUBSTRING(first_name, 2, LENGTH(first_name) - 1))
    )) as Actor_Name
from actor;

-- Trouver le ou les acteurs appelé(s) "JENNIFER"
select * from actor
where upper(first_name) = "JENNIFER";

-- Trouver les acteurs ayant des prénoms de 3 charactères.
select * from actor
where length(first_name) = 3;

-- Afficher les acteurs (actor_id, first_name, last_name, nbre char first_name, nbre char
-- last_name )par ordre décroissant de longueur de prénoms
select actor_id, first_name, last_name, length(first_name) as length_firstname, length(last_name) as length_lastname from actor
order by length(first_name) DESC;

-- Afficher les acteurs (actor_id, first_name, last_name, nbre char first_name, nbre char
-- last_name )par ordre décroissant de longueur de prénoms et croissant de longuer de noms
select actor_id, first_name, last_name, length(first_name) as length_firstname, length(last_name) as length_lastname from actor
order by length(first_name) DESC, length(last_name) ASC;

-- Trouver les acteurs ayant dans leurs last_names la chaine: "SON
select * from actor
where upper(last_name) LIKE '%SON%';

-- Trouver les acteurs ayant des last_names commençant par la chaine: "JOH"
select * from actor
where upper(last_name) LIKE 'JOH%';

-- Afficher par ordre alphabétique croissant les last_names et les first_names des acteurs ayant dans leurs last_names
-- la chaine "LI"

select * from actor
where upper(last_name) LIKE '%LI%'
order by last_name ASC, first_name ASC;

-- trouver dans la table country les countries "China", "Afghanistan", "Bangladesh"
select * from country
where country in ("China", "Afghanistan", "Bangladesh");

-- Ajouter une colonne middle_name entre les colonnes first_name et last_name

-- Alter table actor  
-- Add middle_name varchar(225)  AFTER `first_name`;
select * from actor;

-- Changer le data type de la colonne middle_name au type blobs
describe actor;
ALTER TABLE actor
MODIFY middle_name BLOB;
describe actor;

-- Supprimer la colonne middle_name
ALTER TABLE actor
DROP COLUMN middle_name;
describe actor;

-- Trouver le nombre des acteurs ayant le meme last_name 
-- Afficher le resultat par ordre décroissant

select last_name, count(*) as "Nombre d'acteurs avec ce nom" from actor
group by last_name
order by count(*) DESC;

-- Trouver le nombre des acteurs ayant le meme last_name 
-- Afficher UNIQUEMENT les last_names communs à au moins 3 acteurs
-- Afficher par ordre alph. croissant
select last_name, count(*) as "Nombre d'acteurs avec ce nom" from actor
group by last_name
having count(*) >= 3;

-- Trouver le nombre des acteurs ayant le meme first_name 
-- Afficher le resultat par ordre alph. croissant
select first_name, count(*) from actor
group by first_name
order by first_name ASC;

-- Insérer dans la table actor ,un nouvel acteur , faites attention à l'id!
-- Modifier le first_name du nouvel acteur à "Jean"
-- Supprimer le dernier acteur inséré de la table actor

insert into actor(first_name, last_name, last_update)
values("Ahmed", "Mohamedi", NOW());

select * from actor;

UPDATE actor
SET first_name = 'Jean'
WHERE actor_id = 201;

select * from actor
where first_name = "Jean";

DELETE FROM actor WHERE first_name = "Jean";

select * from actor;

-- Corriger le first_name de l'acteur HARPO WILLIAMS qui était accidentellement inséré à GROUCHO
-- WILLIAMS

select * from actor
where upper(first_name) = "GROUCHO"; 

update actor
set first_name = "HARPO"
where actor_id = 172;

select * from actor
where upper(first_name) = "HARPO"; 

-- Mettre à jour le first_name dans la table actor pour l'actor_id 173 comme suit: si le first_name
-- ="ALAN" alors remplacer le par "ALLAN" sinon par "MUCHO ALLAN"

-- Normalement 1ere exec -> ALLAN puis MUCHO ALLAN ===> Oui ca fonctionne
select * from actor
where actor_id = 173; 

update actor
set first_name = 
	(CASE
		WHEN first_name = "ALAN" THEN "ALLAN"
        ELSE "MUCHO ALLAN"
    END)
where actor_id = 173;

select * from actor
where actor_id = 173; 

-- Trouver les first_names,last names et l'adresse de chacun des membre staff 
-- RQ: utiliser join avec les tables staff & address

select * from staff;
select * from address;

select first_name, last_name, address.address 
from staff
inner join address on address.address_id = staff.address_id;

-- Afficher pour chaque membre du staff ,le total de ses salaires depuis Aout 2005. 
-- RQ: Utiliser les tables staff & payment.
select * from staff;
select * from payment;

select first_name, last_name, sum(payment.amount) as "salaire_total"
from staff
join payment on staff.staff_id = payment.staff_id
group by staff.staff_id;

-- Afficher pour chaque film ,le nombre de ses acteurs
select * from film;
select * from film_actor;

select film.film_id, film.title, count(actor_id) as "nbr_actor" from film_actor
join film on film.film_id = film_actor.film_id
group by film.film_id
order by count(actor_id) desc;

-- Trouver le film intitulé "Hunchback Impossible"
select film_id from film
where title = "Hunchback Impossible";

-- combien de copies exist t il dans le systme d'inventaire pour le film Hunchback Impossible
select * from film;
select * from inventory;

select film.film_id, film.title, count(store_id) as "nb_copy" from inventory
join film on film.film_id = inventory.film_id
where film.title = "Hunchback Impossible"
group by  inventory.film_id;

-- Afficher les titres des films en anglais commençant par 'K' ou 'Q'
select * from film;
select * from language;

select film_id, title, language.name from film
join language on language.language_id = film.language_id
where title LIKE 'K%' or title LIKE 'Q%';

-- Afficher les first et last names des acteurs qui ont participé au film intitulé 'ACADEMY DINOSAUR'
select * from film;
select * from actor;
select * from film_actor;

select title, actor.last_name, actor.first_name from film f
join film_actor on f.film_id = film_actor.film_id
join actor on actor.actor_id = film_actor.actor_id
where title = "ACADEMY DINOSAUR";

-- Trouver la liste des film catégorisés comme family films.
select * from film;
select * from category;
select * from film_category;

select title, category.name from film
join film_category on film.film_id = film_category.film_id
join category on category.category_id = film_category.category_id
where name = "Family";

-- Afficher le top 5 des films les plus loués par ordre decroissant
select * from film;
select * from rental;
select * from inventory;

select title, count(rental.inventory_id) as "nb_location" from film
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
group by title
order by count(rental.inventory_id) desc
LIMIT 5;

-- Afficher la liste des stores : store ID, city, country
select * from store;
select * from address;
select * from city;
select * from country;

select store_id, address.address, city.city, country.country from store
join address on store.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id;

-- Afficher le chiffre d'affaire par store. 
-- RQ: le chiffre d'affaire = somme (amount)

select * from store;
select * from payment;
select * from staff;

select store.store_id, sum(payment.amount) as "CA_total"
from store
join staff on staff.store_id = store.store_id
join payment on staff.staff_id = payment.staff_id
group by store.store_id;

-- Lister par ordre décroissant le top 5 des catégories ayant le plus des revenues. 
-- RQ utiliser les tables : category, film_category, inventory, payment, et rental.

select * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;

select category.name, sum(payment.amount) as "CA_total_per_genre" from category
join film_category on category.category_id = film_category.category_id
join inventory on inventory.film_id = film_category.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

-- Créer une view top_five_genres avec les résultat de la requete precedante.
CREATE OR REPLACE VIEW top_five_genres AS
select category.name, sum(payment.amount) as "CA_total_per_genre" from category
join film_category on category.category_id = film_category.category_id
join inventory on inventory.film_id = film_category.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

SELECT * FROM top_five_genres;

-- Supprimer la table top_five_genres
DROP VIEW top_five_genres;

