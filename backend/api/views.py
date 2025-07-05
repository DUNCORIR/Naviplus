#!/usr/bin/python3
"""
This module defines the viewsets for the Naviplus API.

ViewSets:
- BuildingViewSet: Handles CRUD for building data.
- PLDViewSet: Handles CRUD for building entrance descriptors.
- UserProfileViewSet: Returns current user profile info.

All viewsets are built using Django REST Framework's ModelViewSet.
"""

from rest_framework import viewsets, permissions, status
from .models import Building, PLD, UserProfile
from .serializers import BuildingSerializer, PLDSerializer, UserProfileSerializer
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view, permission_classes
from django.shortcuts import get_object_or_404

# ================== ViewSets ==================

class BuildingViewSet(viewsets.ModelViewSet):
    """
    API endpoint to list, create, update, and delete Building entries.
    """
    queryset = Building.objects.all()
    serializer_class = BuildingSerializer
    permission_classes = [IsAuthenticated]


class PLDViewSet(viewsets.ModelViewSet):
    """
    API endpoint to manage Physical Location Descriptors (PLDs).
    """
    serializer_class = PLDSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """
        Optional filtering of PLDs by building ID via query param.
        Example: /api/plds/?building=1
        """
        queryset = PLD.objects.all()
        building_id = self.request.query_params.get('building')
        if building_id:
            queryset = queryset.filter(building_id=building_id)
        return queryset


class UserProfileViewSet(viewsets.ModelViewSet):
    """
    API endpoint to create, retrieve, update, or delete the authenticated user's profile.
    """
    serializer_class = UserProfileSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """
        Limits queryset to only profiles owned by the authenticated user.
        """
        return UserProfile.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        """
        Automatically assign the current user when creating a profile.
        """
        serializer.save(user=self.request.user)

# ================== Custom Auth Endpoint ==================

@api_view(['POST'])
@permission_classes([permissions.AllowAny])  # Anyone can register
def signup(request):
    """
    Creates a new user and returns an authentication token.
    """
    username = request.data.get('username')
    password = request.data.get('password')

    if not username or not password:
        return Response({'error': 'Username and password are required.'}, status=status.HTTP_400_BAD_REQUEST)

    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already exists.'}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.create_user(username=username, password=password)
    token, _ = Token.objects.get_or_create(user=user)

    return Response({'token': token.key}, status=status.HTTP_201_CREATED)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def navigate(request):
    """
    Simulates indoor navigation between two PLDs (entrance points) in a building.
    Expects query params: ?building=1&start=Entrance A&end=Lift B
    Returns step-by-step instructions (mocked).
    """
    building_id = request.query_params.get('building')
    start = request.query_params.get('start')
    end = request.query_params.get('end')

    if not all([building_id, start, end]):
        return Response({'error': 'Missing parameters: building, start, end required.'},
                        status=status.HTTP_400_BAD_REQUEST)

    building = get_object_or_404(Building, pk=building_id)
    plds = building.plds.all()

    start_pld = plds.filter(entrance_name__iexact=start).first()
    end_pld = plds.filter(entrance_name__iexact=end).first()

    if not start_pld or not end_pld:
        return Response({'error': 'Start or end point not found in building.'},
                        status=status.HTTP_404_NOT_FOUND)

    # ✨ Mock navigation logic — simulate a real path
    steps = [
        f"Start at {start_pld.entrance_name}.",
        "Proceed straight for 10 meters.",
        "Turn right at the hallway junction.",
        f"Arrive at {end_pld.entrance_name}."
    ]

    return Response({'steps': steps}, status=status.HTTP_200_OK)