class Leather < ApplicationRecord
	has_one_attached :image
	has_many_attached :leather_photos
	has_many_attached :shoes_photos
	has_many_attached :bags_photos
	has_many_attached :other_photos

	validates :number, presence: true
	validates :name, presence: true
	validates :description, presence: true, length: {minimum: 100}
	validates :status, presence: true
	validates :nature, presence: true
	validates :sheen, presence: true
	validates :hardness, presence: true
	validates :texture, presence: true
	validates :color1, presence: true
	validates :mprotection, presence: true
	validates :image, presence: true

	self.per_page = 100

	extend FriendlyId
	friendly_id :number, use: :slugged

	filterrific(
	 available_filters: [
		:search_query,
		:with_color,
		:with_nature,
		:with_hardness,
		:with_sheen
	 ]
	)

	scope :search_query, ->(query) {
	  return nil if query.blank?

	  terms = query.to_s
	  terms = terms.downcase.split(/\s+/)

	  terms = terms.map { |e|
	    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
	  }

	  num_or_conds = 2
	  where(
	    terms.map { |_term|
	      "(LOWER(leathers.number) LIKE ? OR LOWER(leathers.name) LIKE ?)"
	    }.join(" AND "),
	    *terms.map { |e| [e] * num_or_conds }.flatten,
	  )
	}

	scope :with_color, ->(color) {
	  where('color1 LIKE :color OR color2 LIKE :color OR color3 LIKE :color', color: color)
	}

	scope :with_nature, ->(nature) {
	  where(nature: [*nature])
	}

	scope :with_hardness, ->(hardness) {
	  where(hardness: [*hardness])
	}

	scope :with_sheen, ->(sheen) {
	  where(sheen: [*sheen])
	}

	def sq_thumb
		return self.image.variant(resize:'800x800', gravity:'center', crop: "1:1", quality: '85').processed
	end

	def sq_mobile
		return self.image.variant(resize:'1000x1000', gravity:'center', crop: "1:1", quality: '70').processed
	end

	def sq_big
		return self.image.variant(resize:'1800x1800', gravity:'center', crop: "1:1", quality: '70').processed
	end

	def sq_full
		return self.image.variant(resize:'2000x2000', quality: '80').processed
	end

	def thumb input
		return input.variant(resize: "800", quality: "75").processed
	end

	def full input
		return input.variant(resize: "2000", quality: "80").processed
	end

	def self.colors
	    [
	    	['Черный', {'data-content'=>"<span class='circle black'></span>Черный"}],
	    	['Коричневый', {'data-content'=>"<span class='circle brown'></span>Коричневый"}],
	     	['Хаки', {'data-content'=>"<span class='circle khaki'></span>Хаки"}],
	     	['Рыжий', {'data-content'=>"<span class='circle orange'></span>Рыжий"}],
	     	['Желтый', {'data-content'=>"<span class='circle yellow'></span>Желтый"}],
	     	['Зеленый', {'data-content'=>"<span class='circle green'></span>Зеленый"}],
	     	['Серый', {'data-content'=>"<span class='circle gray'></span>Серый"}],
	     	['Белый', {'data-content'=>"<span class='circle white'></span>Белый"}],
	     	['Бежевый', {'data-content'=>"<span class='circle beige'></span>Бежевый"}],
	     	['Синий', {'data-content'=>"<span class='circle blue'></span>Синий"}],
	     	['Красный', {'data-content'=>"<span class='circle red'></span>Красный"}],
	     	['Розовый', {'data-content'=>"<span class='circle pink'></span>Розовый"}],
	     	['Диско', {'data-content'=>"<span class='circle disco'></span>Диско"}]
	     	

	    ]
	end

	def self.natures
	    ['Лицевая', 'Хорс жированный', 'Хорс вощеный', 'Краст', 'Лак', 'Спилок', 'Нубук', 'Велюр', 'Юфть']
	end

	def self.hardness
	    ['Мягкая', 'Средняя', 'Жесткая']
	end

	def self.sheen
	    ['Матовая', 'Полуглянцевая', 'Глянцевая']
	end
end
