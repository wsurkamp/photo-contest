class Admin::PagesController < Admin::ApplicationController
  before_action :admin_user, except: [:index, :show, :route]
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :default_pages, only: [:destroy]

  def index
    @pages = Page.all
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to [:admin, @page], notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to [:admin, @page], notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_url, notice: 'Page was successfully destroyed.'
  end

  def route
    @page = Page.find_by(permalink: params[:permalink])

    if @page
      render template: 'static_pages/index'
    else
      page_not_found
    end
  end

  private
    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:name, :permalink, :content)
    end

    def page_not_found
      head :not_found
    end

    def default_pages
      ids = Page.where("permalink = ? OR permalink = ?",  'about', 'contact').pluck(:id)
      if @page.id == ids[0] or @page.id == ids[1]
        redirect_to admin_pages_url, notice: 'Esta página não pode ser excluída.'
      end
    end

end
