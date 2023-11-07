"""URL mapping for the recipe app
"""
from django.urls import (
    path,
    include
)

from rest_framework.routers import DefaultRouter

from recipe import views

router = DefaultRouter()
router.register('recipes', views.RecipeViewSets) # The recipe viewset autogenerates the endpoint based on funcionality

app_name = 'recipe'

urlpatterns = [
    path('', include(router.urls)),
]
