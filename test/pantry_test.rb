require './lib/pantry'
require './lib/recipe'
require 'minitest/autorun'
require 'minitest/pride'

class PantryTest < Minitest::Test

  def setup
    @pantry = Pantry.new
  end

  def test_it_exists
    assert_instance_of Pantry, @pantry
  end

  def test_it_has_a_stock
    stock = {}
    assert_equal stock, @pantry.stock
  end

  def test_it_can_check_stock
    assert_equal 0, @pantry.stock_check("Cheese")
  end

  def test_it_can_restock
    @pantry.restock("Cheese", 10)
    assert_equal 10, @pantry.stock_check("Cheese")
    @pantry.restock("Cheese", 20)
    assert_equal 30, @pantry.stock_check("Cheese")
  end

  def test_it_can_make_shopping_list
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    @pantry.add_to_shopping_list(r)
    shopping_list = {"Cheese" => 20, "Flour" => 20}
    assert_equal shopping_list, @pantry.shopping_list
  end

  def test_it_can_add_multiple_recipes_to_shopping_list
    r_1 = Recipe.new("Cheese Pizza")
    r_1.add_ingredient("Cheese", 20)
    r_1.add_ingredient("Flour", 20)
    r_2 = Recipe.new("Spaghetti")
    r_2.add_ingredient("Spaghetti Noodles", 10)
    r_2.add_ingredient("Marinara Sauce", 10)
    r_2.add_ingredient("Cheese", 5)
    @pantry.add_to_shopping_list(r_1)
    @pantry.add_to_shopping_list(r_2)
    shopping_list = {"Cheese" => 25,
                     "Flour" => 20,
                     "Spaghetti Noodles" => 10,
                     "Marinara Sauce" => 10}
    assert_equal shopping_list, @pantry.shopping_list
  end

  def test_it_can_print_shopping_list
    r_1 = Recipe.new("Cheese Pizza")
    r_1.add_ingredient("Cheese", 20)
    r_1.add_ingredient("Flour", 20)
    r_2 = Recipe.new("Spaghetti")
    r_2.add_ingredient("Spaghetti Noodles", 10)
    r_2.add_ingredient("Marinara Sauce", 10)
    r_2.add_ingredient("Cheese", 5)
    @pantry.add_to_shopping_list(r_1)
    @pantry.add_to_shopping_list(r_2)
    printed_shopping_list = "* Cheese: 25\n* Flour: 20\n* Spaghetti Noodles: 10\n* Marinara Sauce: 10"
    assert_equal printed_shopping_list, @pantry.print_shopping_list
  end

  def test_it_can_add_to_cookbook
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)
    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)
    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)
    @pantry.add_to_cookbook(r1)
    @pantry.add_to_cookbook(r2)
    @pantry.add_to_cookbook(r3)
    cookbook = [r1.name, r2.name, r3.name]
    assert_equal cookbook, @pantry.cookbook.keys
    recipes = {r1.name => r1, r2.name => r2, r3.name => r3}
    assert_equal recipes, @pantry.cookbook
  end

  def test_pantry_knows_what_it_can_make
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)
    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)
    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)
    @pantry.add_to_cookbook(r1)
    @pantry.add_to_cookbook(r2)
    @pantry.add_to_cookbook(r3)
    @pantry.restock("Cheese", 10)
    @pantry.restock("Flour", 20)
    @pantry.restock("Brine", 40)
    @pantry.restock("Cucumbers", 120)
    @pantry.restock("Raw nuts", 20)
    @pantry.restock("Salt", 20)
    can_make = ["Pickles", "Peanuts"]
    assert_equal true, @pantry.can_i_make_this?(r2)
    assert_equal false, @pantry.can_i_make_this?(r1)
    assert_equal can_make, @pantry.what_can_i_make
  end

  def test_it_knows_how_many_it_can_make
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)
    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)
    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)
    @pantry.add_to_cookbook(r1)
    @pantry.add_to_cookbook(r2)
    @pantry.add_to_cookbook(r3)
    @pantry.restock("Cheese", 10)
    @pantry.restock("Flour", 20)
    @pantry.restock("Brine", 40)
    @pantry.restock("Cucumbers", 120)
    @pantry.restock("Raw nuts", 20)
    @pantry.restock("Salt", 20)
    can_make_number = {"Pickles" => 4, "Peanuts" => 2}
    assert_equal can_make_number, @pantry.how_many_can_i_make
  end

end
