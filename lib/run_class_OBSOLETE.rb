require './config/environment.rb'


class Run

    attr_reader :input

    def self.initial_input
        puts "Enter a search term to search by meal name.\nYou can also search by category or region by typing 'Category' or 'Region'\n\n"
        input = gets.to_s.downcase.chomp
        if input == ""
            puts "Invalid input"
            initial_input
        else
            @input = input 
        end
    end

    def self.integer_input
        input = gets.chomp.to_i
        if input > 0
            input-1
        else
            puts "Invalid input."
            integer_input
        end
    end

    def user_input
        input = gets.to_s.downcase.chomp
        if input == ""
            puts "Invalid input"
            initial_input
        else
            @input = input 
        end
    end


    def self.get_results
        
        
        if @input == "region" || @input == "area"

            puts "\nSure! What would you like to search for? (i.e., 'Mecixan', 'Chinese', etc.)"
            area_input = gets.chomp.to_s.downcase
            get_region = GetRequest.new("https://www.themealdb.com/api/json/v1/1/filter.php?a=#{area_input}").response_json["meals"]
            
            if get_region == nil
                puts "\nCouldn't find any #{area_input.capitalize} recipes!\n"
                initial_input
                get_results(@input)
            else
                

                puts "\nHere are some #{area_input.capitalize} recipes:\n---"
                
                Recipe.names_with_index(Recipe.create_new_recipes(get_region))

                puts "\nWhich recipe would you like to open? (please enter a number)\n"
                recipe_selection = integer_input
                
                if recipe_selection > Recipe.names.length || recipe_selection < 0
                    puts "Invalid selection"
                    get_results(@input)

                else
                    Recipe.create_new_recipes(GetRequest.new("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{Recipe.all[recipe_selection].idMeal}").response_json["meals"])
                    puts "\n#{Recipe.all.last.strMeal}\n---\nInstructions:\n#{Recipe.all.last.strInstructions}"
                end
            end

        elsif @input == "category"

            puts "\nSure! Which category would you like to search?"
            category_input = gets.chomp.to_s.downcase
            
            get_category = GetRequest.new("https://www.themealdb.com/api/json/v1/1/filter.php?c=#{category_input}").response_json["meals"]
            
            if get_category == nil
                puts "\nCouldn't find any #{category_input} recipes!\n"
                initial_input
                get_results(@input)

            else
                Recipe.create_new_recipes(get_category)

                puts "\nHere are some #{category_input} recipes:\n---"

                Recipe.names_with_index(Recipe.create_new_recipes(get_category))

                puts "\nWhich recipe would you like to open? (please enter a number)\n"
                recipe_selection = gets.to_i-1
                
                if recipe_selection > Recipe.names.length || recipe_selection < 0
                    puts "Invalid selection"
                    get_results(@input)

                else
                    Recipe.create_new_recipes(GetRequest.new("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{Recipe.all[recipe_selection].idMeal}").response_json["meals"])
                    puts "\n#{Recipe.all.last.strMeal}\n---\nInstructions:\n#{Recipe.all.last.strInstructions}"
                end
                
            end

        else

            returned_recipes = GetRequest.new("https://www.themealdb.com/api/json/v1/1/search.php?s=#{@input}").response_json["meals"]
        

            if returned_recipes == nil
                puts "\nCouldn't find any recipes with '#{@input}' in the name!\n"
                initial_input
                get_results(@input)
            else
                puts "Here are some recipes with #{@input} in the name:\n---"
                Recipe.names_with_index(Recipe.create_new_recipes(returned_recipes))
                
                puts "\nWhich recipe would you like to open? (please enter a number)\n"
                recipe_selection = gets.to_i-1
                
                if recipe_selection > Recipe.names.length || recipe_selection < 0
                    puts "Invalid selection"
                    get_results(@input)

                else
                    puts "\n#{Recipe.all[recipe_selection].strMeal}\n---\nInstructions:\n#{Recipe.all[recipe_selection].strInstructions}"
                end
            end
        end
    end
end