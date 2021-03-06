class Pantry
  attr_reader :stock, :shopping_list, :cookbook

  def initialize
    @stock = Hash.new(0)
    @shopping_list = Hash.new(0)
    @cookbook = {}
  end

  def stock_check(item)
    @stock[item]
  end

  def restock(item, number)
    @stock[item] += number
  end

  def add_to_shopping_list(recipe)
    recipe.ingredients.each do |item, amount|
      @shopping_list[item] += amount
    end
  end

  def print_shopping_list
    items = []
    @shopping_list.each do |item, amount|
      items << "* #{item}: #{amount}"
    end
    puts items.join("\n")
    items.join("\n")
  end

  def add_to_cookbook(recipe)
    @cookbook[recipe.name] = recipe
  end

  def needed_for_recipe(recipe)
    needed = {}
    recipe.ingredient_types.each do |ingredient|
      needed[ingredient] = recipe.amount_required(ingredient)
    end
    needed
  end

  def can_i_make_this?(recipe)
    needed = needed_for_recipe(recipe)
    needed.each do |ingredient, amount|
      return false if stock_check(ingredient) < amount
    end
    return true
  end

  def what_can_i_make
    can_make = []
    @cookbook.each do |name, recipe|
      if can_i_make_this?(recipe)
        can_make << name
      end
    end
    can_make
  end

  def how_many_of_these(recipe)
    needed = needed_for_recipe(recipe)
    times = needed.map do |ingredient, amount|
     stock_check(ingredient) / amount
   end.min
  end

  def how_many_can_i_make
    can_make_many = {}
    @cookbook.each do |name, recipe|
      if can_i_make_this?(recipe)
        can_make_many[name] = how_many_of_these(recipe)
      end
    end
    can_make_many
  end
end
